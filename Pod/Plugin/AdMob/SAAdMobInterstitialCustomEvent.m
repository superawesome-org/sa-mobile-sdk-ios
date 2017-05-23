#import "SAAdMobInterstitialCustomEvent.h"
#import "SAInterstitialAd.h"

static NSString *const interstitialErrorDomain = @"tv.superawesome.SAAdMobInterstitialCustomEvent";

@interface SAAdMobInterstitialCustomEvent ()

@property (nonatomic, assign) NSInteger placementId;

@end

@implementation SAAdMobInterstitialCustomEvent

@synthesize delegate;

- (void) requestInterstitialAdWithParameter:(NSString *)serverParameter
                                      label:(NSString *)serverLabel
                                    request:(GADCustomEventRequest *)request {
    
    
    _placementId = [serverParameter integerValue];
    
    if (_placementId == 0) {
        if (delegate != nil) {
            NSError *error = [NSError errorWithDomain:interstitialErrorDomain code:0 userInfo:nil];
            [self.delegate customEventInterstitial:self didFailAd:error];
        }
        return;
    }
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    [SAInterstitialAd setTestMode:[request isTesting]];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                [weakSelf.delegate customEventInterstitialDidReceiveAd:weakSelf];
                break;
            }
            case adAlreadyLoaded:
                break;
            case adFailedToLoad: {
                NSError *error = [NSError errorWithDomain:interstitialErrorDomain code:0 userInfo:nil];
                [weakSelf.delegate customEventInterstitial:weakSelf didFailAd:error];
                break;
            }
            case adShown: {
                [weakSelf.delegate customEventInterstitialWillPresent:weakSelf];
                break;
            }
            case adFailedToShow:
                break;
            case adClicked: {
                [weakSelf.delegate customEventInterstitialWasClicked:weakSelf];
                [weakSelf.delegate customEventInterstitialWillLeaveApplication:weakSelf];
                break;
            }
            case adEnded:
                break;
            case adClosed: {
                [weakSelf.delegate customEventInterstitialWillDismiss:weakSelf];
                [weakSelf.delegate customEventInterstitialDidDismiss:weakSelf];
                break;
            }
        }
    }];
    
}

- (void) presentFromRootViewController:(UIViewController *)rootViewController {
    if ([SAInterstitialAd hasAdAvailable:_placementId]) {
        [SAInterstitialAd play:_placementId fromVC:rootViewController];
    }
}

@end
