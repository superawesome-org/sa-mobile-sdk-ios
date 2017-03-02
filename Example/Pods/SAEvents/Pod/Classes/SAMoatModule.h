/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;
@class AVPlayer;
@class AVPlayerLayer;

@interface SAMoatModule : NSObject

- (id) initWithAd: (SAAd*) ad;

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
