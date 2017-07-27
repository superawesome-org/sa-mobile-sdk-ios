/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

/**
 * Protocol describing thne methods that a view conforming to the 
 * parental gate protocol will need to implement.
 */
@protocol SAParentalGateProtocol <NSObject>

/**
 * Method part of SAParentalGateProtocol called when the gate is opened
 *
 * @param position int representing the ad position in the ads response array
 */
- (void) parentalGateOpen:(NSInteger) position;

/**
 * Method part of SAParentalGateProtocol called when the gate is successful
 *
 * @param position    int representing the ad position in the ads response array
 * @param destination URL destination to go to after the parental gate is OK
 */
- (void) parentalGateSuccess:(NSInteger) position
              andDestination:(NSString*)destination;

/**
 * Method part of SAParentalGateProtocol called when the gate is failed
 *
 * @param position int representing the ad position in the ads response array
 */
- (void) parentalGateFailure:(NSInteger) position;

/**
 * Method part of SAParentalGateProtocol called when the gate is closed
 *
 * @param position int representing the ad position in the ads response array
 */
- (void) parentalGateCancel:(NSInteger) position;

@end
