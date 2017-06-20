#import "SAAdMobBannerCustomEvent.h"
#import "SABannerAd.h"
#import "SAAdMobExtras.h"

// error domain
#define kERROR_DOMAIN @"tv.superawesome.SAAdMobBannerCustomEvent"

@interface SAAdMobBannerCustomEvent ()

// a SA banner instance
@property (nonatomic, strong) SABannerAd *bannerAd;

@end

@implementation SAAdMobBannerCustomEvent

@synthesize delegate;

- (void) requestBannerAd:(GADAdSize)adSize
               parameter:(NSString *)serverParameter
                   label:(NSString *)serverLabel
                 request:(GADCustomEventRequest *)request {
    
    
    //
    // Step 1. get the palcement Id from the server parameter
    NSInteger placementId = [serverParameter integerValue];
    
    //
    // Step 1.1 check the placement Id to see if it's different from 0
    // (meaning the parameter sent isn't a proper number, as expected by SA)
    // and if it's not, cause an error
    if (placementId == 0) {
        if (delegate != nil) {
            NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
            [self.delegate customEventBanner:self didFailAd:error];
        }
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    //
    // Step 2. Init the banner ad
    _bannerAd = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, adSize.size.width, adSize.size.height)];
    
    //
    // Step 3. customise the banner ad with values taken from additional
    // parameters sent by the user
    NSDictionary *params = [request additionalParameters];
    
    if (params != nil) {
        [_bannerAd setTestMode:[[params objectForKey:kKEY_TEST] boolValue]];
        [_bannerAd setConfiguration:[[params objectForKey:kKEY_CONFIGURATION] integerValue]];
        [_bannerAd setParentalGate:[[params objectForKey:kKEY_PARENTAL_GATE] boolValue]];
        [_bannerAd setColor:[[params objectForKey:kKEY_TRANSPARENT] boolValue]];
    }
    
    //
    // Step 4. Add callbacks
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                
                //
                // send event
                [weakSelf.delegate customEventBanner:weakSelf didReceiveAd:weakSelf.bannerAd];
                
                //
                // play ad
                [weakSelf.bannerAd play];
                break;
            }
            case adEmpty: {
                //
                // send error in this case
                NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
                [weakSelf.delegate customEventBanner:weakSelf didFailAd:error];
                break;
            }
            case adFailedToLoad: {
                //
                // send error in this case
                NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
                [weakSelf.delegate customEventBanner:weakSelf didFailAd:error];
                break;
            }
            case adClicked: {
                //
                // send clicked and leave events
                [weakSelf.delegate customEventBannerWasClicked:weakSelf];
                [weakSelf.delegate customEventBannerWillLeaveApplication:weakSelf];
                break;
            }
            //
            // non supported SA events
            case adAlreadyLoaded:
            case adShown:
            case adFailedToShow:
            case adEnded:
            case adClosed:
                break;
        }
    }];
    
    //
    // Step 5. Load the AD
    [_bannerAd load:placementId];
}


@end
