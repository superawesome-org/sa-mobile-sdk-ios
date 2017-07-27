/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAParentalGateProtocol.h"

@class SAAd;

/**
 * Class that defines a parental gate - basically a pop-up that, when enables, forces users to
 * respond to a mini-math quiz in order to proceed forward
 */
@interface SAParentalGate : NSObject <UIAlertViewDelegate>


/**
 * Init method with the ad position and the final click destination
 *
 * @param position    position of the ad in the ads response array
 * @param destination URL destination of the click
 */
- (id) initWithPosition:(NSInteger) position
         andDestination:(NSString*) destination;

// delegate of the parental gate
@property (nonatomic, weak) id <SAParentalGateProtocol> delegate;

/**
 * Main show method
 */
- (void) show;

/**
 * Main close method
 */
- (void) close;

@end
