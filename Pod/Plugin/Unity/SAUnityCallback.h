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


static inline void sendToUnity (NSString *unityName, NSDictionary *data) {
    
    const char *name = [unityName UTF8String];
    NSString *payload = [data jsonCompactStringRepresentation];
    const char *payloadUTF8 = [payload UTF8String];
    UnitySendMessage (name, "nativeCallback", payloadUTF8);
    
}

static inline void sendAdCallback (NSString *unityName, NSInteger placementId, NSString *callback) {

    NSDictionary *data = @{
                           @"placementId": [NSString stringWithFormat:@"%ld", (long) placementId],
                           @"type": [NSString stringWithFormat:@"sacallback_%@", callback]
                           };
    
    sendToUnity(unityName, data);
    
}

static inline void sendCPICallback (NSString *unityName, BOOL success, NSString *callback) {
    
    NSDictionary *data = @{
                           @"boolean": [NSString stringWithFormat:@"%d", success],
                           @"type": [NSString stringWithFormat:@"sacallback_%@", callback]
                           };
    sendToUnity(unityName, data);
    
}
