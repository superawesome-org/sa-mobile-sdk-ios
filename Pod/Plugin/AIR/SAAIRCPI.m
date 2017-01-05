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

FREObject SuperAwesomeAIRSuperAwesomeHandleCPI (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [[SuperAwesome getInstance] handleCPI];
    return NULL;
}
