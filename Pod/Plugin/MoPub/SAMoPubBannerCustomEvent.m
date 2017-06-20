/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAMoPubBannerCustomEvent.h"
#import "SAMoPub.h"
#import "SuperAwesome.h"
#import "NSDictionary+SafeHandling.h"

@interface SAMoPubBannerCustomEvent ()
@property (nonatomic, strong) SABannerAd *banner;
@end

@implementation SAMoPubBannerCustomEvent

/**
 * Overridden MoPub method that requests a banner ad of a certain size, with
 * additional info from the network.
 *
 * @param size a CGSize value detailing the size of the ad
 * @param info a dictionary of extra information passed down from MoPub to the
 *             SDK that help with loading the ad
 */
- (void) requestAdWithSize:(CGSize) size
           customEventInfo:(NSDictionary*) info {
    
    NSInteger placementId = [[info safeObjectForKey:PLACEMENT_ID orDefault:@(SA_DEFAULT_PLACEMENTID)] integerValue];
    BOOL isTestEnabled = [[info safeObjectForKey:TEST_ENABLED orDefault:@(SA_DEFAULT_TESTMODE)] boolValue];
    BOOL isPrentalGateEnabled = [[info safeObjectForKey:PARENTAL_GATE orDefault:@(SA_DEFAULT_PARENTALGATE)] boolValue];
    
    SAConfiguration configuration = SA_DEFAULT_CONFIGURATION;
    
    NSString *conf = [info safeStringForKey:CONFIGURATION];
    if (conf != nil && [conf isEqualToString:@"STAGING"]) {
        configuration = STAGING;
    }
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // create a new banner
    _banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_banner setConfiguration:configuration];
    [_banner setTestMode:isTestEnabled];
    [_banner setParentalGate:isPrentalGateEnabled];

    [_banner setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                [weakSelf.delegate bannerCustomEvent:weakSelf didLoadAd:weakSelf.banner];
                [weakSelf.banner play];
                break;
            }
            case adAlreadyLoaded:{
                // do nothing
                break;
            }
            case adEmpty: {
                [weakSelf.delegate bannerCustomEvent:weakSelf
                            didFailToLoadAdWithError:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Banner Ad", placementId)
                                                                     andReason:ERROR_LOAD_MESSAGE
                                                                 andSuggestion:ERROR_LOAD_SUGGESTION]];
                break;
            }
            case adFailedToLoad: {
                [weakSelf.delegate bannerCustomEvent:weakSelf
                            didFailToLoadAdWithError:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Banner Ad", placementId)
                                                                     andReason:ERROR_NETWORK_MESSAGE
                                                                 andSuggestion:ERROR_NETWORK_SUGGESTION]];
                break;
            }
            case adShown: {
                break;
            }
            case adFailedToShow: {
                [weakSelf.delegate bannerCustomEvent:weakSelf
                            didFailToLoadAdWithError:[weakSelf createErrorWith:ERROR_SHOW_TITLE(@"Banner Ad", 0)
                                                                     andReason:ERROR_SHOW_MESSAGE
                                                                 andSuggestion:ERROR_SHOW_SUGGESTION]];
                break;
            }
            case adClicked: {
                [weakSelf.delegate bannerCustomEventWillLeaveApplication:weakSelf];
                break;
            }
            case adEnded:{
                // do nothing
                break;
            }
            case adClosed: {
                break;
            }
        }
    }];
    
    // load
    [_banner load:placementId];
}

/**
 * MoPub method that creates a new error obkect
 * 
 * @param description   the description text of the error
 * @param reason        a reason for why it might have happened
 * @param suggestion    a suggestion of how to fix it
 */
- (NSError*) createErrorWith:(NSString*) description
                   andReason:(NSString*) reason
               andSuggestion:(NSString*) suggestion {
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE userInfo:userInfo];
}

@end
