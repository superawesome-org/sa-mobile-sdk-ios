//
//  SABanner.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 11/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SABannerView.h"
#import "UIView+FindUIViewController.h"
#import "SuperAwesome.h"

@interface SABannerView ()

@property (nonatomic,strong) ATBannerView *bannerView;
@property (nonatomic,assign) BOOL isBannerConfigured;
@property (nonatomic,strong) SAParentalGate *gate;
@property (nonatomic,strong) NSURL *adURL;

@end

@implementation SABannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.bannerView = [[ATBannerView alloc] initWithFrame:self.bounds];
    self.bannerView.delegate = self;
    [self addSubview:self.bannerView];
}

//#if TARGET_INTERFACE_BUILDER
//- (void)prepareForInterfaceBuilder
//{
//    if([self isSupportedSize:self.bounds.size]){
//        NSBundle *bundle = [NSBundle bundleForClass:self.class];
//        NSString *fileName = [bundle pathForResource:[NSString stringWithFormat:@"AdDemo%@x%@", @(self.bounds.size.width), @(self.bounds.size.height)] ofType:@"jpg"];
//        UIImage *image = [UIImage imageWithContentsOfFile:fileName];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [imageView sizeToFit];
//        [self addSubview:imageView];
//    }else{
//        UIColor *saColor = [UIColor colorWithRed:0.8 green:0.17 blue:0.09 alpha:1];
//        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
//        [label setText:@"Invalid size!\nCheck the documentation for the list of supported banner sizes."];
//        [label setTextColor:[UIColor whiteColor]];
//        [label setBackgroundColor:saColor];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        [label setNumberOfLines:0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [self addSubview:label];
//    }
//}
//#endif

- (NSArray *)supportedBannerSizes
{
    return @[[NSValue valueWithCGSize:CGSizeMake(320, 50)],
             [NSValue valueWithCGSize:CGSizeMake(300, 50)],
             [NSValue valueWithCGSize:CGSizeMake(300, 250)],
             [NSValue valueWithCGSize:CGSizeMake(728, 90)],
             [NSValue valueWithCGSize:CGSizeMake(768, 1024)],
             [NSValue valueWithCGSize:CGSizeMake(320, 480)]];
}

- (BOOL)isSupportedSize:(CGSize)aSize
{
    NSArray *sizes = [self supportedBannerSizes];
    for(NSValue *size in sizes){
        if(CGSizeEqualToSize([size CGSizeValue], aSize)){
            return YES;
        }
    }
    return NO;
}

- (void)loadBanner
{
    if(self.isBannerConfigured == NO) return;
    
    if(self.viewController == nil){
        UIViewController *vc = [self firstAvailableUIViewController];
        self.viewController = vc;
    }
    
    [self.bannerView load];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if(self.window == nil){
        self.visible = NO;
        return;
    }
    
    self.visible = YES;
    [[SuperAwesome sharedManager] displayAdForApp:self.appID placement:self.placementID completion:^(SADisplayAd *displayAd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(displayAd == nil){
                NSLog(@"SA: Could not find placement with the provided placement ID");
            }else{
                self.bannerView.configuration = [self configurationWithDisplayAd:displayAd];
                self.isBannerConfigured = YES;
                [self loadBanner];
            }
        });
    }];
}

- (void)removeFromSuperview
{
    [self.bannerView removeFromSuperview];
    
    [super removeFromSuperview];
}

- (void)setVisible:(BOOL)visible
{
    _visible = visible;
    self.bannerView.visible = visible;
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    self.bannerView.viewController = viewController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ATBannerViewDelegate

- (void)shouldSuspendForAd:(ATBannerView *)view
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shouldSuspendForAd:)]){
        [self.delegate shouldSuspendForAd:self];
    }
}

- (void)shouldResumeForAd:(ATBannerView *)view
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shouldResumeForAd:)]){
        [self.delegate shouldResumeForAd:self];
    }
}

- (void)willLeaveApplicationForAd:(ATBannerView *)view
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(willLeaveApplicationForAd:)]){
        [self.delegate willLeaveApplicationForAd:self];
    }
}

- (void)didFetchNextAd:(ATBannerView*)view signals:(NSArray *)signals
{
    NSLog(@"SA: Ad fetched from ad server");
}

- (void)didFailFetchingAd:(ATBannerView*)view signals:(NSArray *)signals
{
    NSLog(@"SA: Failed to load ad from server");
    if(self.delegate && [self.delegate respondsToSelector:@selector(shouldDisplayCustomMediationForAd:)]){
        [self.delegate shouldDisplayCustomMediationForAd:self];
    }
}

- (BOOL)shouldOpenLandingPageForAd:(ATBannerView *)view withURL:(NSURL *)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController
{
    if([self isParentalGateEnabled]){
        if(self.gate == nil){
            self.gate = [[SAParentalGate alloc] init];
            self.gate.delegate = self;
        }
        [self.gate show];
        self.adURL = URL;
        
        return NO;
    }
    return YES;
}

- (void)didStopOnCustomMediation:(ATBannerView*)view
{
    NSLog(@"SA: didStopOnCustomMediation");
    if(self.delegate && [self.delegate respondsToSelector:@selector(shouldDisplayCustomMediationForAd:)]){
        [self.delegate shouldDisplayCustomMediationForAd:self];
    }
}

#pragma mark SAParentalGateDelegate

- (void)didGetThroughParentalGate:(SAParentalGate *)parentalGate
{
    [[UIApplication sharedApplication] openURL:self.adURL];
}

@end
