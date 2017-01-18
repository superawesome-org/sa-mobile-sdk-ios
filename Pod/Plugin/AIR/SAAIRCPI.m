//
//  SAAIRCPI.c
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#include "SAAIRCPI.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesomeSDK.h>)
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
#else
#import "SuperAwesome.h"
#endif
#endif

#import "SAAIRCallback.h"

FREObject SuperAwesomeAIRSuperAwesomeHandleCPI (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    [[SuperAwesome getInstance] handleCPI:^(BOOL success) {
        
        sendCPICallback(ctx, @"SuperAwesomeCPI", success, @"HandleCPI");
        
    }];
    
    return NULL;
}

FREObject SuperAwesomeAIRSuperAwesomeHandleStagingCPI (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    [[SuperAwesome getInstance] handleStagingCPI:^(BOOL success) {
        
        sendCPICallback(ctx, @"SuperAwesomeCPI", success, @"HandleStagingCPI");
        
    }];
    
    return NULL;
}
