#import "SAAdMobBannerCustomEvent.h"
#import "SABannerAd.h"

static NSString *const bannerErrorDomain = @"tv.superawesome.SAAdMobBannerCustomEvent";

@interface SAAdMobBannerCustomEvent ()

@property (nonatomic, strong) SABannerAd *bannerAd;

@end

@implementation SAAdMobBannerCustomEvent

@synthesize delegate;

- (void) requestBannerAd:(GADAdSize)adSize
               parameter:(NSString *)serverParameter
                   label:(NSString *)serverLabel
                 request:(GADCustomEventRequest *)request {
    
    
    NSInteger placementId = [serverParameter integerValue];
    
    if (placementId == 0) {
        if (delegate != nil) {
            NSError *error = [NSError errorWithDomain:bannerErrorDomain code:0 userInfo:nil];
            [self.delegate customEventBanner:self didFailAd:error];
        }
        return;
    }
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    _bannerAd = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, adSize.size.width, adSize.size.height)];
    [_bannerAd setTestMode:[request isTesting]];
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                
                // play ad
                [weakSelf.bannerAd play];
                
                // send
                [weakSelf.delegate customEventBanner:weakSelf didReceiveAd:weakSelf.bannerAd];
                break;
            }
            case adAlreadyLoaded:
                break;
            case adFailedToLoad: {
                NSError *error = [NSError errorWithDomain:bannerErrorDomain code:0 userInfo:nil];
                [weakSelf.delegate customEventBanner:weakSelf didFailAd:error];
                break;
            }
            case adShown:
                break;
            case adFailedToShow:
                break;
            case adClicked: {
                [weakSelf.delegate customEventBannerWasClicked:weakSelf];
                [weakSelf.delegate customEventBannerWillLeaveApplication:weakSelf];
                break;
            }
            case adEnded:
                break;
            case adClosed:
                break;
        }
    }];
    [_bannerAd load:placementId];
}

@end
