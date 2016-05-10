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
@interface SuperAwesomeBannerCustomEvent () <SALoaderProtocol, SAAdProtocol, SAParentalGateProtocol>

@property (nonatomic, assign) CGRect bannerFrame;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, strong) SALoader *loader;
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
    _isTestEnabled = [isTestEnabledObj boolValue];
    _placementId = [placementIdObj integerValue];
    _isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    
    // code from SA to load ad
    _bannerFrame = CGRectMake(0, 0, size.width, size.height);
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:_isTestEnabled];
    
    // start the loader
    _loader = [[SALoader alloc] init];
    [_loader setDelegate:self];
    [_loader loadAdForPlacementId:_placementId];

}

#pragma mark Custom Functions

- (NSError*) createErrorWith:(NSString*)description andReason:(NSString*)reaason andSuggestion:(NSString*)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE userInfo:userInfo];
}

#pragma mark <SALoaderProtocol>

- (void) didLoadAd:(SAAd *)ad {
    // first step is to actually create the Ad View, as defined by SuperAwesome
    _banner = [[SABannerAd alloc] initWithFrame:_bannerFrame];
    
    // set delegates
    [_banner setAdDelegate:self];
    [_banner setParentalGateDelegate:self];
    
    // customize
    [_banner setIsParentalGateEnabled:_isParentalGateEnabled];
    
    // set ad
    [_banner setAd:ad];
    
    // play
    [_banner play];
    
    // and then send it to bannerCustomEvent:didLoadAd:
    [self.delegate bannerCustomEvent:self didLoadAd:_banner];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[self createErrorWith:ERROR_LOAD_TITLE(@"Banner Ad", placementId)
                                                 andReason:ERROR_LOAD_MESSAGE
                                             andSuggestion:ERROR_LOAD_SUGGESTION]];
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    // do nothing
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[self createErrorWith:ERROR_SHOW_TITLE(@"Banner Ad", placementId)
                                                 andReason:ERROR_SHOW_MESSAGE
                                             andSuggestion:ERROR_SHOW_SUGGESTION]];
}

- (void) adWasClicked:(NSInteger)placementId {
    // this must be called to log clicks to MoPub
    if (!_isParentalGateEnabled){
        [self.delegate bannerCustomEventWillLeaveApplication:self];
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    // do nothing
}

#pragma mark <SAParentalGateProtocol>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    // do nothing here
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    // do nothing here
}


@end
