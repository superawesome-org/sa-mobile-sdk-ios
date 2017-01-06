//
//  SAUnityVersion.c
//  Pods
//
//  Created by Gabriel Coman on 06/01/2017.
//
//

#import <UIKit/UIKit.h>

#if defined(__has_include)
#if __has_include("SuperAwesomeSDKUnity.h")
#import "SuperAwesomeSDKUnity.h"
#else
#import "SuperAwesome.h"
#endif
#endif

extern "C" {
    
    void SuperAwesomeUnitySetVersion(const char *versionString, const char *sdkString) {
        
        NSString *version = [NSString stringWithUTF8String:versionString];
        NSString *sdk = [NSString stringWithUTF8String:sdkString];
        
        [[SuperAwesome getInstance] overrideVersion:version];
        [[SuperAwesome getInstance] overrideSdk:sdk];
        
    }
    
}
