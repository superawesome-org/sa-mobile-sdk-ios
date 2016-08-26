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
@interface SuperAwesomeBannerCustomEvent () <SAProtocol>
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
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:isTestEnabled];
    
    // create a new banner
    _banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_banner setIsParentalGateEnabled:isParentalGateEnabled];
    _banner.delegate = self;
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

// MARK: SAProtocol

- (void) SADidLoadAd:(id)sender forPlacementId:(NSInteger)placementId {
    
    // and then send it to bannerCustomEvent:didLoadAd:
    [self.delegate bannerCustomEvent:self didLoadAd:_banner];
    
    // play the ad
    [_banner play];
}

- (void) SADidNotLoadAd:(id)sender forPlacementId:(NSInteger)placementId {
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[self createErrorWith:ERROR_LOAD_TITLE(@"Banner Ad", placementId)
                                                 andReason:ERROR_LOAD_MESSAGE
                                             andSuggestion:ERROR_LOAD_SUGGESTION]];
}

- (void) SADidShowAd:(id)sender {
    // do nothing
}

- (void) SADidNotShowAd:(id)sender {
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[self createErrorWith:ERROR_SHOW_TITLE(@"Banner Ad", 0)
                                                 andReason:ERROR_SHOW_MESSAGE
                                             andSuggestion:ERROR_SHOW_SUGGESTION]];
}

- (void) SADidClickAd:(id)sender {
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

- (void) SADidCloseAd:(id)sender {
    // do nothing
}


@end
