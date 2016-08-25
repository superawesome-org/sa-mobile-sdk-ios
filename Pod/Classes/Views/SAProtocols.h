//
//  SAProtocols.h
//  Pods
//
//  Created by Gabriel Coman on 14/02/2016.
//
//

#import <Foundation/Foundation.h>

// useful imports
@class SAAd;

// internal protocol that all ad view objects need to respect
@protocol SAViewProtocol <NSObject>

// load the ad
- (void) load:(NSInteger) placementId;

// set the ad
- (void) setAd:(SAAd*)ad;

// get the ad
- (SAAd*) getAd;

// show padlock
- (BOOL) shouldShowPadlock;

// play ad
- (void) play;

// close the ad
- (void) close;

// second pass at trying to go to URL
- (void) click;

// resize view or view controller
- (void) resize:(CGRect)frame;

@end

// external protocol for ad view objects to communicate w/ user
@protocol SAProtocol <NSObject>

@optional

// all functions are optional here
- (void) SADidLoadAd:(id) sender forPlacementId: (NSInteger) placementId;
- (void) SADidNotLoadAd:(id) sender forPlacementId: (NSInteger) placementId;
- (void) SADidShowAd:(id) sender;
- (void) SADidNotShowAd:(id) sender;
- (void) SADidCloseAd:(id) sender;
- (void) SADidClickAd:(id) sender;

@end