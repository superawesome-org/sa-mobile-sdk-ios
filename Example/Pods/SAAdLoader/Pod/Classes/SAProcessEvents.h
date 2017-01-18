/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

@class SAAd;
@class SASession;

/**
 * Class that, based on a given type of session (a SASession object) 
 * generates a number of custom events that need to be added to an ad object 
 * (a SAAd object passed as parameter)
 */
@interface SAProcessEvents : NSObject

/**
 * Static method that looks at the current session and generates a number 
 * of additional events that will be used by the SDK
 *
 * @param ad        reference to the Ad that the events should be appended to
 * @param session   the current session
 */
+ (void) addAdEvents:(SAAd*) ad
          forSession:(SASession*) session;

@end
