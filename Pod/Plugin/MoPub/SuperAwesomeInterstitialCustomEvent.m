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
#import "SuperAwesomeInterstitialCustomEvent.h"
#import "SuperAwesome.h"
#import "SuperAwesomeMoPub.h"

// private anonymous category of SuperAwesomeBannerCustomEvent, that
// implements two important ad protocols
// - SALoaderProtocol (of SALoader class)
// - SAAdProtocol (common to all SAViews)
@interface SuperAwesomeInterstitialCustomEvent () <SALoaderProtocol, SAAdProtocol, SAParentalGateProtocol>

@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldLockOrientation;
@property (nonatomic, assign) NSUInteger lockOrientation;
@property (nonatomic, strong) SALoader *loader;
@property (nonatomic, strong) SAInterstitialAd *interstitial;

@end

@implementation SuperAwesomeInterstitialCustomEvent

- (void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    id _Nullable placementIdObj = [info objectForKey:PLACEMENT_ID];
    id _Nullable isTestEnabledObj = [info objectForKey:TEST_ENABLED];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:PARENTAL_GATE];
    id _Nullable shouldLockOrientationObj = [info objectForKey:SHOULD_LOCK];
    id _Nullable lockOrientationObj = [info objectForKey:LOCK_ORIENTATION];
    
    if (isTestEnabledObj == NULL || placementIdObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate interstitialCustomEvent:self
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
    _shouldLockOrientation = (shouldLockOrientationObj != NULL ? [shouldLockOrientationObj boolValue] : false);
    if (lockOrientationObj != NULL) {
        NSString *orient = [lockOrientationObj string];
        if ([orient isEqualToString:@"LANDSCAPE"]){
            _lockOrientation = UIInterfaceOrientationMaskLandscape;
        } else if ([orient isEqualToString:@"PORTRAIT"]){
            _lockOrientation = UIInterfaceOrientationMaskPortrait;
        } else {
            _shouldLockOrientation = NO;
        }
    }
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:_isTestEnabled];
    
    // start the loader
    _loader = [[SALoader alloc] init];
    [_loader setDelegate:self];
    [_loader loadAdForPlacementId:_placementId];
}

- (void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    
    __weak typeof (self) weakSelf = self;
    
    [rootViewController presentViewController:_interstitial animated:YES completion:^{
        
        // call events
        [weakSelf.delegate interstitialCustomEventWillAppear:weakSelf];
        
        // play preloaded ad
        [weakSelf.interstitial play];
    }];
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
    // init interstitial
    _interstitial = [[SAInterstitialAd alloc] init];
    
    // set parameters
    [_interstitial setIsParentalGateEnabled:_isParentalGateEnabled];
    
    // set delegate
    [_interstitial setAdDelegate:self];
    [_interstitial setParentalGateDelegate: self];
    [_interstitial setShouldLockOrientation:_shouldLockOrientation];
    [_interstitial setLockOrientation:_lockOrientation];
    
    // set ad
    [_interstitial setAd:ad];
    
    // call events
    [self.delegate interstitialCustomEvent:self didLoadAd:_interstitial];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:ERROR_LOAD_TITLE(@"Interstitial Ad", placementId)
                                                       andReason:ERROR_LOAD_MESSAGE
                                                   andSuggestion:ERROR_LOAD_SUGGESTION]];
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    [_interstitial close];
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:ERROR_SHOW_TITLE(@"Interstitial Ad", placementId)
                                                       andReason:ERROR_SHOW_MESSAGE
                                                   andSuggestion:ERROR_SHOW_SUGGESTION]];
}

- (void) adWasClicked:(NSInteger)placementId {
    // call required event
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    
    // only show this directly if PG is not enabled
    // if it is, it will be called when PG is successfull
    if (!_isParentalGateEnabled) {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    // call required events
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
    
    // null these so no references remain and memory is freed
    _interstitial = NULL;
    _loader = NULL;
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    [_interstitial close];
}

#pragma mark <SAParentalGateProtocol>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    // do nothing here
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    // do nothing here
}

@end
