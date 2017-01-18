/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;
@class AVPlayer;
@class AVPlayerLayer;

// typical event response (used mostly for testing purposes atm)
typedef void (^saDidGetEventResponse) (BOOL success, NSInteger status);

/**
 * Class that abstracts away the sending of events to the ad server. 
 * It also handles triggering and disabling Moat Events
 */
@interface SAEvents : NSObject

/**
 * Important setter that adds an ad to a SAEvents instance
 *
 * @param ad a new (hopefully valid) ad
 */
- (void) setAd:(SAAd*) ad;

/**
 * Basic method to send events to an URL using the network object
 *
 * @param url      URL to send an event to
 * @param response an instance of the saDidGetEventResponse to 
 *                 receive the answer on
 */
- (void) sendEventToURL:(NSString*) url
           withResponse:(saDidGetEventResponse) response;

/**
 * Shorthand send event method that has no callback
 *
 * @param url URL to send an event to
 */
- (void) sendEventToURL:(NSString*) url;

/**
 * Method that sends all events for a particular "key" in 
 * the "events" list of an ad
 *
 * @param key      the key to search events for in the "events" list
 * @param response an instance of the saDidGetEventResponse to
 *                 receive the answer on
 */
- (void) sendAllEventsForKey:(NSString*) key
                withResponse:(saDidGetEventResponse) response;

/**
 * Shorthand version of the previous method, without a listener
 *
 * @param key the key to search events for in the "events" list
 */
- (void) sendAllEventsForKey:(NSString*) key;

/**
 * Method that sends a viewable impression for a view. 
 * SuperAwesome calculates viewable impression conditions for banner, 
 * interstitial, etc, ads using IAB standards
 *
 * @param child    the child view
 * @param maxTicks max ticks to check the view is visible on the screen 
 *                 before triggering the viewable impression event
 * @param response an instance of the saDidGetEventResponse to
 */
- (void) sendViewableImpressionForView:(UIView*) view
                              andTicks:(NSInteger) maxTicks
                          withResponse:(saDidGetEventResponse) response;

/**
 * Shorthand method to send a viewable impression for a Display ad
 *
 * @param view the child view
 */
- (void) sendViewableImpressionForDisplay:(UIView*) view;

/**
 * Shorthand method to send a viewable impression for a Video ad
 *
 * @param view the child view
 */
- (void) sendViewableImpressionForVideo:(UIView*) view;

/**
 * Method that closes the event object (and disables timers, etc)
 */
- (void) close;

/**
 * Method that registers a Moat event object, 
 * according to the moat specifications
 *
 * @param webplayer the web view used by Moat to register events on 
 *                  (and that will contain an ad at runtime)
 * @return          returns a MOAT specific string that will need to be 
 *                  inserted in the web view so that the JS moat stuff works
 */
- (NSString*) moatEventForWebPlayer:(id)webplayer;

/**
 * Method that registers a Video Moat event
 *
 * @param video     the current AVPlayer needed by Moat to do video tracking
 * @param layer     the current Player layer associated with the video view
 * @return          whether the video moat event started OK
 */
- (BOOL) moatEventForVideoPlayer:(AVPlayer*) player
                       withLayer:(AVPlayerLayer*) layer
                         andView:(UIView*) view;

/**
 * Method by which Moat can be fully enforced by disabling 
 * any limiting applied to it
 */
- (void) disableMoatLimiting;

@end
