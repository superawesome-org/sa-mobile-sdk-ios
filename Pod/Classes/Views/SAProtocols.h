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

////////////////////////////////////////////////////////////////////////////////

// @brief:
// This protocol informs the user about different events in the lifecylce
// of a normal Ad;
// It has to be implemented as a delegate object by any child of
// SAView, meaning any Ad type is valid
@protocol SAAdProtocol <NSObject>

@optional

// this function is called when the ad is shown on the screen
- (void) adWasShown:(NSInteger)placementId;

// this function is called when the ad failed to show
- (void) adFailedToShow:(NSInteger)placementId;

// this function is called when an ad is closed;
// only applies to fullscreen ads like interstitials and fullscreen videos
- (void) adWasClosed:(NSInteger)placementId;

// this function is called when an ad is clicked
- (void) adWasClicked:(NSInteger)placementId;

@end

////////////////////////////////////////////////////////////////////////////////

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
