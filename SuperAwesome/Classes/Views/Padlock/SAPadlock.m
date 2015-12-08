//
//  SAPadlock.m
//  Pods
//
//  Created by Gabriel Coman on 05/12/2015.
//
//

// import header
#import "SAPadlock.h"

// get the saview header
#import "SAView.h"

// import modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import padlock view
#import "SAPadlockView.h"

// import saaux
#import "SAAux.h"

@interface SAPadlock ()

// the actual padlock
@property (nonatomic, strong) UIView *padlockView;

// internal ad
@property (nonatomic, strong) SAAd *ad;

// weak ref to ad view
@property (nonatomic, weak) SAView *weakAdView;

// the padlock button
@property (nonatomic, strong) UIButton *padlockBtn;

// the actual padlock view
@property (nonatomic, strong) SAPadlockView *pad;

@end

@implementation SAPadlock

- (id) initWithWeakRefToView:(SAView *)weakRef {
    if (self = [super init]) {
        _weakAdView = weakRef;
        _ad = [_weakAdView ad];
    }
    
    return self;
}

- (void) addPadlockButtonToSubview:(UIView *)view {
    // don't go any further is ad is fallback
    if (_ad.isFallback) {
        return;
    }
    
    // add the padlock button
    CGRect main_frame = view.frame;
    
    CGSize padlock_size = CGSizeMake(15, 15);
    CGRect padlock_frame = CGRectMake((main_frame.size.width - padlock_size.width),
                                      (main_frame.size.height - padlock_size.height),
                                      padlock_size.width,
                                      padlock_size.height);
    
    _padlockBtn = [[UIButton alloc] initWithFrame:padlock_frame];
    [_padlockBtn setImage:[UIImage imageNamed:@"sa_padlock"] forState:UIControlStateNormal];
    [_padlockBtn addTarget:self action:@selector(onPadlockClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_padlockBtn];
    [view bringSubviewToFront:_padlockBtn];
}

- (void) removePadlockButton {
    
    [_padlockBtn removeFromSuperview];
    
    if (_padlockBtn) {
        _padlockBtn = NULL;
    }
}

#pragma mark <PadlockButton> action

- (void) onPadlockClick {
//    if (!_pad) {
//        _pad = [[SAPadlockView alloc] initWithAd:_ad];
//    }
//    
//    // show this
//    [[[[UIApplication sharedApplication] delegate] window] addSubview:_pad];
}

@end
