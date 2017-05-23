#import "SAAdMobVideoCustomEvent.h"
#import "SuperAwesome.h"
#import "SAVideoAd.h"

static NSString *const videoErrorDomain = @"tv.superawesome.SAAdMobVideoCustomEvent";

@interface SAAdMobVideoCustomEvent ()

@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> connector;

@end

@implementation SAAdMobVideoCustomEvent

+ (NSString *)adapterVersion {
    return [[SuperAwesome getInstance] getSdkVersion];
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return Nil;
}

- (instancetype)initWithRewardBasedVideoAdNetworkConnector:
(id<GADMRewardBasedVideoAdNetworkConnector>)connector{
 
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _connector = connector;
    }
    return self;
}

- (void) setUp {
    
    NSString *parameter = [self.connector.credentials objectForKey:GADCustomEventParametersServer];
    _placementId = [parameter integerValue];
    if (_placementId == 0) {
        NSError *error = [NSError errorWithDomain:videoErrorDomain code:0 userInfo:nil];
        [_connector adapter:self didFailToSetUpRewardBasedVideoAdWithError:error];
        return;
    }
    
    [SAVideoAd setTestMode:[_connector testMode]];
    [_connector adapterDidSetUpRewardBasedVideoAd:self];
}

- (void) requestRewardBasedVideoAd {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        switch (event) {
            case adLoaded: {
                [weakSelf.connector adapterDidReceiveRewardBasedVideoAd:weakSelf];
                break;
            }
            case adAlreadyLoaded:
                break;
            case adFailedToLoad: {
                NSError *error = [NSError errorWithDomain:videoErrorDomain code:0 userInfo:nil];
                [weakSelf.connector adapter:weakSelf didFailToLoadRewardBasedVideoAdwithError:error];
                break;
            }
            case adShown: {
                [weakSelf.connector adapterDidOpenRewardBasedVideoAd:weakSelf];
                [weakSelf.connector adapterDidStartPlayingRewardBasedVideoAd:weakSelf];
                break;
            }
            case adFailedToShow:
                break;
            case adClicked: {
                [weakSelf.connector adapterDidGetAdClick:weakSelf];
                [weakSelf.connector adapterWillLeaveApplication:weakSelf];
                break;
            }
            case adEnded: {
                break;
            }
            case adClosed: {
                [weakSelf.connector adapterDidCloseRewardBasedVideoAd:weakSelf];
                break;
            }
        }
        
    }];
    
    // actually load Ad
    [SAVideoAd load:_placementId];
    
}

- (void) presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    if ([SAVideoAd hasAdAvailable:_placementId]) {
        [SAVideoAd play:_placementId fromVC:viewController];
    }
}

- (void) stopBeingDelegate {
    // do nothing
}

@end
