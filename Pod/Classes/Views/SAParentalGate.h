/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;

/**
 * Class that defines a parental gate - basically a pop-up that, when enables, forces users to
 * respond to a mini-math quiz in order to proceed forward
 */
@interface SAParentalGate : NSObject <UIAlertViewDelegate>

/**
 * Init method with a weak reference to the calling view (banner,
 * interstitial or video ad and an reference to the ad that's being played)
 * 
 * @param weakRef a param of type "id"
 * @param ad      the current SAAd object being played
 */
- (id) initWithWeakRefToView:(id) weakRef
                       andAd:(SAAd*) ad;

/**
 * Init method with a weak reference to the calling view (appwall) 
 * and an reference to the ad that's being played)
 *
 * @param weakRef   a param of type "id"
 * @param ad        the current SAAd object being played
 * @param postiion  the current ad position in the appwall
 */
- (id) initWithWeakRefToView:(id) weakRef
                       andAd:(SAAd*) ad
                 andPosition:(NSInteger) position;

/**
 * Main show method
 */
- (void) show;

/**
 * Main close method
 */
- (void) close;

@end
