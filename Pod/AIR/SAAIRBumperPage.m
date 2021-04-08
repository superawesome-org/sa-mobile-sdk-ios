/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#include "SAAIRVersion.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SABumperPage.h>)
#import <SuperAwesomeSDK/SABumperPage.h>
#else
#import "SABumperPage.h"
#endif
#endif

FREObject SuperAwesomeAIRBumperOverrideName (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    uint32_t nameLength;
    const uint8_t *nameUTF8;
    
    FREGetObjectAsUTF8(argv[0], &nameLength, &nameUTF8);
    
    NSString *name = [NSString stringWithUTF8String:(char*)nameUTF8];
    
    [SABumperPage overrideName:name];
    
    return NULL;
}
