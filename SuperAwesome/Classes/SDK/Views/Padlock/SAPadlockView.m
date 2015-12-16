//
//  SAPadlockView2.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import "SAPadlockView.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SASender.h"

// Defines constants for padlock texts
#define SA_PADLOCKVIEW_TITLE @"About SA Ads"
#define SA_PADLOCKVIEW_SUBTITLE1 @"This is SuperAwesome kid-safe ad. Click here for more information."
#define SA_PADLOCKVIEW_SUBTITLE2 @"Rate this Ad"
#define SA_PADLOCKVIEW_SUBTITLE3 @"Share your oppinion:"
#define SA_PADLOCKVIEW_OKBUTTON_TITLE @"OK"
#define SA_PADLOCK_URL @"http://www.superawesome.tv/en/"

@interface SAPadlockView ()

// internal (private) outlets
@property (strong, nonatomic) UIView *view;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *infoPanel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *Title;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *Subtitle1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *Subtitle2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *Subtitle3;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *rateButtons;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *OKBtn;

// touch responder to close
@property (nonatomic, strong) UITapGestureRecognizer *tapToClose;

// current rating
@property (nonatomic, assign) int currentRating;

// the internal ad
@property (nonatomic, retain) SAAd *ad;

@end

@implementation SAPadlockView

// designated init
- (id) init {
    if (self = [super init]) {
        // make current rating
        _currentRating = -1;
        
        // setup the pop-up frame
        self.frame = [UIScreen mainScreen].bounds;
        
        // load the view from a NIB / XIB file
        _view = [[[NSBundle mainBundle] loadNibNamed:@"SAPadlockView" owner:self options:nil] firstObject];
        _view.frame = self.frame;
        [self addSubview:_view];
        
        // do some more panel view setup
        _infoPanel.layer.shadowColor = [UIColor blackColor].CGColor;
        _infoPanel.layer.shadowOpacity = 0.25f;
        _infoPanel.layer.shadowRadius = 2.25f;
        _infoPanel.layer.shadowOffset = CGSizeMake(0, 0);
        
        // setup texts
        _Title.text = SA_PADLOCKVIEW_TITLE;
        _Subtitle2.text = SA_PADLOCKVIEW_SUBTITLE2;
        _Subtitle3.text = SA_PADLOCKVIEW_SUBTITLE3;
        [_OKBtn setTitle:SA_PADLOCKVIEW_OKBUTTON_TITLE forState:UIControlStateNormal];
        
        // make subtitle text be attributed
        NSRange range = [SA_PADLOCKVIEW_SUBTITLE1 rangeOfString:@"here"];
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:SA_PADLOCKVIEW_SUBTITLE1];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        [attString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        
        _Subtitle1.attributedText = attString;
        
        // setup tags
        short i = 0;
        for (UIButton *rateBtn in _rateButtons) {
            i++;
            rateBtn.tag = i;
        }
        
        // get the tap part
        _tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:_tapToClose];
    }
    
    return self;
}

// custom init functions
- (id) initWithAd:(SAAd *)ad {
    if (self = [self init]) {
        _ad = ad;
    }
    
    return self;
}

- (id) initWithPlacementId:(NSInteger)placementId
             andCreativeId:(NSInteger)creativeId
             andLineItemId:(NSInteger)lineItemId {
    if (self = [self init]) {
        // form the ad from bits and pieces
        _ad = [[SAAd alloc] init];
        _ad.creative = [[SACreative alloc] init];
        _ad.placementId = placementId;
        _ad.lineItemId = lineItemId;
        _ad.creative.creativeId = creativeId;
    }
    
    return self;
}

// rate the current ad
- (IBAction) rateAction:(id)sender{
    for (UIButton *rateBtn in _rateButtons) {
        [rateBtn setSelected:false];
    }
    
    for (short i = 0; i < [sender tag]; i++) {
        [_rateButtons[i] setSelected:true];
        _currentRating = (i+1);
    }
}

// when tapping outside the info panel's frame,
// close the view
- (void) tapAction:(UITapGestureRecognizer*)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self];
    CGRect panelFrame = _infoPanel.frame;
    
    if (!CGRectContainsPoint(panelFrame, touchPoint)) {
        [self closeThisView];
    }
}

// when pressing the OK button,
// close the view
- (IBAction)okBtnAction:(id)sender {
    
    [self closeThisView];
}

// properly close the view
- (void) closeThisView {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (IBAction)hiddenHereButtonAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SA_PADLOCK_URL]];
}


@end
