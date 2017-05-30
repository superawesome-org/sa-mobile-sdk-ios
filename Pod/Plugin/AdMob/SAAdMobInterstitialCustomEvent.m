#import "SAAdMobInterstitialCustomEvent.h"
#import "SAInterstitialAd.h"
#import "SAAdMobExtras.h"

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobInterstitialCustomEvent"

@interface SAAdMobInterstitialCustomEvent ()

//
// current placement Id
@property (nonatomic, assign) NSInteger placementId;

@end

@implementation SAAdMobInterstitialCustomEvent

@synthesize delegate;

- (void) requestInterstitialAdWithParameter:(NSString *)serverParameter
                                      label:(NSString *)serverLabel
                                    request:(GADCustomEventRequest *)request {
    
    
    //
    // Step 1. get the palcement Id from the server parameter
    _placementId = [serverParameter integerValue];
    
    //
    // Step 1.1 check the placement Id to see if it's different from 0
    // (meaning the parameter sent isn't a proper number, as expected by SA)
    // and if it's not, cause an error
    if (_placementId == 0) {
        if (delegate != nil) {
            NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
            [self.delegate customEventInterstitial:self didFailAd:error];
        }
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    //
    // Step 2. customise the banner ad with values taken from additional
    // parameters sent by the user
    NSDictionary *params = [request additionalParameters];
    
    if (params != nil) {
        [SAInterstitialAd setTestMode:[[params objectForKey:kKEY_TEST] boolValue]];
        [SAInterstitialAd setParentalGate:[[params objectForKey:kKEY_PARENTAL_GATE] boolValue]];
        [SAInterstitialAd setOrientation:[[params objectForKey:kKEY_ORIENTATION] intValue]];
        [SAInterstitialAd setConfiguration:[[params objectForKey:kKEY_CONFIGURATION] intValue]];
    }
    
    //
    // Step 3. Add callbacks
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                //
                // send event to AdMob
                [weakSelf.delegate customEventInterstitialDidReceiveAd:weakSelf];
                break;
            }
            case adFailedToLoad: {
                //
                // send error info to AdMob
                NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
                [weakSelf.delegate customEventInterstitial:weakSelf didFailAd:error];
                break;
            }
            case adShown: {
                //
                // send event to AdMob
                [weakSelf.delegate customEventInterstitialWillPresent:weakSelf];
                break;
            }
            case adClicked: {
                //
                // send click & leve to AdMob
                [weakSelf.delegate customEventInterstitialWasClicked:weakSelf];
                [weakSelf.delegate customEventInterstitialWillLeaveApplication:weakSelf];
                break;
            }
            case adClosed: {
                //
                // send will & did dismiss to AdMob
                [weakSelf.delegate customEventInterstitialWillDismiss:weakSelf];
                [weakSelf.delegate customEventInterstitialDidDismiss:weakSelf];
                break;
            //
            // non supported SA events
            case adAlreadyLoaded:
            case adFailedToShow:
            case adEnded:
                break;
            }
        }
    }];
    
    //
    // Step 4. Actually load the ad if we go to here
    [SAInterstitialAd load:_placementId];
    
}

- (void) presentFromRootViewController:(UIViewController *)rootViewController {
    //
    // Step 5. If SA says we have an ad, play it from the root controller
    // indicated by AdMob
    if ([SAInterstitialAd hasAdAvailable:_placementId]) {
        [SAInterstitialAd play:_placementId fromVC:rootViewController];
    }
}

@end
