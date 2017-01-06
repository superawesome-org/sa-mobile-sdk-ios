//
//  SAAIRVersion.c
//  Pods
//
//  Created by Gabriel Coman on 06/01/2017.
//
//

#include "SAAIRVersion.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesomeSDK.h>)
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
#else
#import "SuperAwesome.h"
#endif
#endif

FREObject SuperAwesomeAIRSetVersion (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    uint32_t versionLength;
    const uint8_t *versionUTF8;
    
    uint32_t sdkLength;
    const uint8_t *sdkUTF8;
    
    FREGetObjectAsUTF8(argv[0], &versionLength, &versionUTF8);
    FREGetObjectAsUTF8(argv[1], &sdkLength, &sdkUTF8);
    
    NSString *version = [NSString stringWithUTF8String:(char*)versionUTF8];
    NSString *sdk = [NSString stringWithUTF8String:(char*)sdkUTF8];
    
    [[SuperAwesome getInstance] overrideVersion:version];
    [[SuperAwesome getInstance] overrideSdk:sdk];
    
    return NULL;
}
