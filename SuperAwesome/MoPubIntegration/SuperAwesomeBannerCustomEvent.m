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
#import "SuperAwesome.h"

// private anonymous category of SuperAwesomeBannerCustomEvent, that
// implements two important ad protocols
// - SALoaderProtocol (of SALoader class)
// - SAAdProtocol (common to all SAViews)
@interface SuperAwesomeBannerCustomEvent () <SALoaderProtocol, SAAdProtocol>

@property (nonatomic, assign) CGRect bannerFrame;
@property (nonatomic, strong) SABannerAd *banner;
@property (nonatomic, assign) BOOL parentalGate;

@end

// actual implementation
@implementation SuperAwesomeBannerCustomEvent

// main CustomEvent call function
- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    BOOL testMode = false;
    BOOL isParentalGateEnabled = true;
    NSInteger placementId = -1;
    
    id _Nullable testModeObj = [info objectForKey:@"testMode"];
    id _Nullable placementIdObj = [info objectForKey:@"placementId"];
    id _Nullable parentalGateEnabledObj = [info objectForKey:@"parentalGateEnabled"];
    
    if (testModeObj == NULL || placementIdObj == NULL || parentalGateEnabledObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate bannerCustomEvent:self
                didFailToLoadAdWithError:[self createErrorWith:@"Failed to get correct custom data from MoPub server."
                                                     andReason:@"Either \"testMode\" or \"placementId\" parameters are wrong."
                                                 andSuggestion:@"Make sure your custom data JSON has format: { \"placementId\":XXX, \"testMode\":true/false }"]];
        
        // return
        return;
    }
    
    // assign values, because they exist
    testMode = [testModeObj boolValue];
    placementId = [placementIdObj integerValue];
    isParentalGateEnabled = [parentalGateEnabledObj boolValue];
    _parentalGate = isParentalGateEnabled;
    
    // enable or disable test mode
    if (testMode) {
        [[SuperAwesome sharedManager] enableTestMode];
    }
    else {
        [[SuperAwesome sharedManager] disableTestMode];
    }
    
    // code from SA to load ad
    _bannerFrame = CGRectMake(0, 0, size.width, size.height);
    
    [[SALoader sharedManager] setDelegate:self];
    [[SALoader sharedManager] preloadAdForPlacementId:placementId];
}

#pragma mark Custom Functions

- (NSError*) createErrorWith:(NSString*)description andReason:(NSString*)reaason andSuggestion:(NSString*)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:@"SuperAwesomeErrorDomain" code:0 userInfo:userInfo];
}

#pragma mark SALoaderProtocol functions

- (void) didPreloadAd:(SAAd *)ad forPlacementId:(NSInteger)placementId {

    // first step is to actually create the Ad View, as defined by SuperAwesome
    _banner = [[SABannerAd alloc] initWithFrame:_bannerFrame];
    [_banner setAd:ad];
    [_banner setDelegate:self];
    [_banner setIsParentalGateEnabled:_parentalGate];
    [_banner playPreloaded];
    
    // and then send it to bannerCustomEvent:didLoadAd:
    [self.delegate bannerCustomEvent:self didLoadAd:_banner];
}

- (void) didFailToPreloadAdForPlacementId:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[self createErrorWith:[NSString stringWithFormat:@"Failed to preload SuperAwesome Banner Ad for PlacementId: %ld", placementId]
                                                 andReason:@"The operation timed out."
                                             andSuggestion:@"Check your placement Id."]];
    
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[self createErrorWith:[NSString stringWithFormat:@"Failed to display SuperAwesome Banner Ad for PlacementId: %ld", placementId]
                                                 andReason:@"JSON invalid."
                                             andSuggestion:@"Contact SuperAwesome support: <devsuppoer@superawesome.tv>"]];
}

- (void) adFollowedURL:(NSInteger)placementId {
    
    // this must be called to log clicks to MoPub
    [self.delegate bannerCustomEventWillLeaveApplication:self];
    
}

@end
