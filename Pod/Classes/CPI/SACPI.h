/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SAInstallEvent.h"

/**
 * Class that handles sending an /install event to the ad server and
 * return a callback block informing the SDK user if the operation was
 * successfull or not.
 */
@interface SACPI : NSObject

/**
 * Main class method
 *
 * @param session   the current session to operate against
 * @param response  a callback block of type "saDidCountAnInstall"
 */
- (void) sendInstallEvent: (SASession*) session
             withCallback: (saDidCountAnInstall) response;

@end
