/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#include "SAAIRCPI.h"
#import "SAAIRCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesomeSDK.h>)
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
#else
#import "SuperAwesome.h"
#endif
#endif

FREObject SuperAwesomeAIRSACPIHandleCPI (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    [[SACPI getInstance] sendInstallEvent:^(BOOL success) {
        
        sendCPICallback(ctx, @"SACPI", success, @"HandleCPI");
        
    }];
    
    return NULL;
}
