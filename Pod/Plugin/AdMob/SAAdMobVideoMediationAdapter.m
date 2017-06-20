#import "SAAdMobVideoMediationAdapter.h"
#import "SAAdMobExtras.h"
#import "SuperAwesome.h"

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobVideoMediationAdapter"

@interface SAAdMobVideoMediationAdapter ()

//
// placement ID
@property (nonatomic, assign) NSInteger placementId;

//
// anon variable, respecting GADMRewardBasedVideoAdNetworkConnector, acting
// as connector
@property (nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> connector;

@end

@implementation SAAdMobVideoMediationAdapter

+ (NSString *)adapterVersion {
    //
    // just return the current SA SDK version
    return [[SuperAwesome getInstance] getSdkVersion];
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    //
    // expect that if users send extra info, it's going to be
    // as SAAdMobVideoExtra class
    return [SAAdMobVideoExtra class];
}

- (instancetype) initWithRewardBasedVideoAdNetworkConnector: (id<GADMRewardBasedVideoAdNetworkConnector>)connector{
    
    //
    // Step 1. if connector is nil, then fail silently
    if (!connector) {
        return nil;
    }
    
    //
    // Step 2. Init the ad
    self = [super init];
    if (self) {
        _connector = connector;
    }
    return self;
}

- (void) setUp {
    
    //
    // Step 3: try and get the placement Id
    NSString *parameter = [self.connector.credentials objectForKey:GADCustomEventParametersServer];
    _placementId = [parameter integerValue];
    
    //
    // Step 3.1. if placement Id is 0, then it was sent wrong by the server
    // and I should abort
    if (_placementId == 0) {
        NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
        [_connector adapter:self didFailToSetUpRewardBasedVideoAdWithError:error];
        return;
    }
    
    //
    // Step 4. get all extras that might help customise this ad
    SAAdMobVideoExtra *extras = [self.connector networkExtras];
    
    if (extras != nil) {
        [SAVideoAd setTestMode:extras.testEnabled];
        [SAVideoAd setOrientation:extras.orientation];
        [SAVideoAd setParentalGate:extras.parentalGateEnabled];
        [SAVideoAd setCloseButton:extras.closeButtonEnabled];
        [SAVideoAd setCloseAtEnd:extras.closeAtEndEnabled];
        [SAVideoAd setSmallClick:extras.smallCLickEnabled];
        [SAVideoAd setConfiguration:extras.configuration];
    }
    
    //
    // Step 5. finally, if I've gotten to here, I've setup the video ad
    // correctly adns hould proceed
    [_connector adapterDidSetUpRewardBasedVideoAd:self];
}

- (void) requestRewardBasedVideoAd {
    
    __weak typeof (self) weakSelf = self;
    
    //
    // Step 6. Add a callback
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        switch (event) {
            case adLoaded: {
                //
                // send event to AdMob
                [weakSelf.connector adapterDidReceiveRewardBasedVideoAd:weakSelf];
                break;
            }
            case adEmpty: {
                //
                // send error info to AdMob
                NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
                [weakSelf.connector adapter:weakSelf didFailToLoadRewardBasedVideoAdwithError:error];
                break;
            }
            case adFailedToLoad: {
                //
                // send error info to AdMob
                NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
                [weakSelf.connector adapter:weakSelf didFailToLoadRewardBasedVideoAdwithError:error];
                break;
            }
            case adShown: {
                //
                // send open & play to AdMob
                [weakSelf.connector adapterDidOpenRewardBasedVideoAd:weakSelf];
                [weakSelf.connector adapterDidStartPlayingRewardBasedVideoAd:weakSelf];
                break;
            }
            case adClicked: {
                //
                // send click & leve to AdMob
                [weakSelf.connector adapterDidGetAdClick:weakSelf];
                [weakSelf.connector adapterWillLeaveApplication:weakSelf];
                break;
            }
            case adClosed: {
                //
                // send close to AdMob
                [weakSelf.connector adapterDidCloseRewardBasedVideoAd:weakSelf];
                break;
            }
            //
            // non supported SA events
            case adAlreadyLoaded:
            case adFailedToShow:
            case adEnded:
                break;
            
        }
        
    }];
    
    //
    // Step 7. actually load Ad
    [SAVideoAd load:_placementId];
    
}

- (void) presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    //
    // Step 8. If SA says we have an ad, play it from the root controller
    // indicated by AdMob
    if ([SAVideoAd hasAdAvailable:_placementId]) {
        [SAVideoAd play:_placementId fromVC:viewController];
    }
}

- (void) stopBeingDelegate {
    // do nothing
}

@end
