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

// return an Ad
- (SAAd*) getAd;

// show padlock
- (BOOL) shouldShowPadlock;

// play the ad
- (void) play:(NSInteger)placementId;

// close the ad
- (void) close;

// second pass at trying to go to URL
- (void) advanceToClick;

// resize view or view controller
- (void) resizeToFrame:(CGRect)frame;

@end
