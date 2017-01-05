//
//  SAUnityCallback.h
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#import <UIKit/UIKit.h>

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/NSDictionary+SAJson.h>)
#import <SuperAwesomeSDK/NSDictionary+SAJson.h>
#else
#import "NSDictionary+SAJson.h"
#endif
#endif

void UnitySendMessage(const char *identifier, const char *function, const char *payload);

static inline void sendToUnity (NSString *unityName, NSInteger placementId, NSString *callback) {

    const char *name = [unityName UTF8String];
    
    NSDictionary *data = @{
                           @"placementId": @(placementId),
                           @"callback": callback
                           };
    
    NSString *payload = [data jsonCompactStringRepresentation];
    
    const char *payloadUTF8 = [payload UTF8String];
    
    UnitySendMessage(name, "nativeCallback", payloadUTF8);
    
}
