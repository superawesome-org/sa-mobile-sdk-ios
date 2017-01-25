/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * This enum holds all the possible callback values that an ad sends during its lifetime
 *  - adLoaded:         ad was loaded successfully and is ready 
 *                      to be displayed
 *  - adFailedToLoad:   ad was not loaded successfully and will not be 
 *                      able to play
 *  - adAlreadyLoaded   ad was previously loaded in an interstitial, video or
 *                      app wall queue
 *  - adShown:          triggered once when the ad first displays
 *  - adFailedToShow:   for some reason the ad failed to show; technically
 *                      this should never happen nowadays
 *  - adClicked:        triggered every time the ad gets clicked
 *  - adEnded:          triggerd when a video ad ends
 *  - adClosed:         triggered once when the ad is closed;
 */
typedef NS_ENUM(NSInteger, SAEvent) {
    adLoaded = 0,
    adFailedToLoad = 1,
    adAlreadyLoaded = 2,
    adShown = 3,
    adFailedToShow = 4,
    adClicked = 5,
    adEnded = 6,
    adClosed = 7
};

// callback block to send back envets back to the SDK users
typedef void (^sacallback)(NSInteger placementId, SAEvent event);
