//
//  SuperAwesome.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import useful headers
#import "SuperAwesomeBannerCustomEvent.h"
#import "SuperAwesomeMoPub.h"
#import "SuperAwesome.h"

// private anonymous category of SuperAwesomeBannerCustomEvent, that
// implements two important ad protocols
// - SALoaderProtocol (of SALoader class)
// - SAAdProtocol (common to all SAViews)
@interface SuperAwesomeBannerCustomEvent ()
@property (nonatomic, strong) SABannerAd *banner;
@end

// actual implementation
@implementation SuperAwesomeBannerCustomEvent

// main CustomEvent call function
- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    id _Nullable placementIdObj = [info objectForKey:PLACEMENT_ID];
    id _Nullable isTestEnabledObj = [info objectForKey:TEST_ENABLED];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:PARENTAL_GATE];
    
    if (isTestEnabledObj == NULL || placementIdObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate bannerCustomEvent:self
                didFailToLoadAdWithError:[self createErrorWith:ERROR_JSON_TITLE
                                                     andReason:ERROR_JSON_MESSAGE
                                                 andSuggestion:ERROR_JSON_SUGGESTION]];
        
        // return
        return;
    }
    
    // assign values, because they exist
    BOOL isTestEnabled = [isTestEnabledObj boolValue];
    NSInteger placementId = [placementIdObj integerValue];
    BOOL isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);

    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // create a new banner
    _banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_banner setTest:isTestEnabled];
    [_banner setConfigurationProduction];
    [_banner setIsParentalGateEnabled:isParentalGateEnabled];
    [_banner setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                [weakSelf.delegate bannerCustomEvent:weakSelf didLoadAd:weakSelf.banner];
                [weakSelf.banner play];
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
            case adClosed: {
                break;
            }
        }
    }];
    
    // load
    [_banner load:placementId];
}

- (NSError*) createErrorWith:(NSString*)description andReason:(NSString*)reaason andSuggestion:(NSString*)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE userInfo:userInfo];
}

@end
