/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SuperAwesomeBannerCustomEvent.h"
#import "SuperAwesomeMoPub.h"
#import "SuperAwesome.h"

@interface SuperAwesomeBannerCustomEvent ()
@property (nonatomic, strong) SABannerAd *banner;
@end

@implementation SuperAwesomeBannerCustomEvent

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
    
    // variables received from the MoPub server
    id _Nullable placementIdObj = [info objectForKey:PLACEMENT_ID];
    id _Nullable isTestEnabledObj = [info objectForKey:TEST_ENABLED];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:PARENTAL_GATE];
    
    // get values
    BOOL placementId = SA_DEFAULT_PLACEMENTID;
    BOOL isTestEnabled = SA_DEFAULT_TESTMODE;
    BOOL isPrentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    
    if (placementIdObj) {
        placementId = [placementIdObj integerValue];
    }
    if (isTestEnabledObj) {
        isTestEnabled = [isTestEnabledObj boolValue];
    }
    if (isParentalGateEnabledObj) {
        isPrentalGateEnabled = [isParentalGateEnabledObj boolValue];
    }
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // create a new banner
    _banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_banner setConfigurationProduction];
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
            case adFailedToLoad: {
                [weakSelf.delegate bannerCustomEvent:weakSelf
                            didFailToLoadAdWithError:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Banner Ad", placementId)
                                                                     andReason:ERROR_LOAD_MESSAGE
                                                                 andSuggestion:ERROR_LOAD_SUGGESTION]];
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
