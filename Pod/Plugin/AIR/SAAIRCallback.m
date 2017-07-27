/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#include "SAAIRCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/NSDictionary+SAJson.h>)
#import <SuperAwesomeSDK/NSDictionary+SAJson.h>
#else
#import "NSDictionary+SAJson.h"
#endif
#endif

void sendToAIR (FREContext context, NSDictionary *data) {
    
    if (context != NULL) {
        
        NSString *package = [data jsonCompactStringRepresentation];
        const uint8_t* packageUTF8 = (const uint8_t*) [package UTF8String];
        const uint8_t* trailerUTF = (const uint8_t*) "";
        FREDispatchStatusEventAsync(context, packageUTF8, trailerUTF);
    }
    
}

void sendAdCallback (FREContext context, NSString *name, int placementId, NSString *callback) {
    
    NSDictionary *data = @{
                           @"name": name,
                           @"placementId": @(placementId),
                           @"callback": callback
                           };
    sendToAIR(context, data);
    
}
