//
//  SAAIRSuperAwesome.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 13/05/2018.
//

#import "SAAIRSuperAwesome.h"
#import "SAAIRCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesome.h>)
#import <SuperAwesomeSDK/SuperAwesome.h>
#else
#import "SuperAwesome.h"
#endif
#endif

FREObject SuperAwesomeAIRInit (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    uint32_t loggingEnabled = false; // boolean
    FREGetObjectAsBool(argv[0], &loggingEnabled);
    [SuperAwesome initSDK:loggingEnabled];
    return NULL;
}

FREObject SuperAwesomeAIRTriggerAgeCheck (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    uint32_t ageLength;
    const uint8_t *ageUTF8;
    FREGetObjectAsUTF8(argv[0], &ageLength, &ageUTF8);
    NSString *age = [NSString stringWithUTF8String:(char*)ageUTF8];
    
    [SuperAwesome triggerAgeCheck:age response:^(GetIsMinorModel *model) {
        
        if (model != nil) {
            NSDictionary *dictionary = [model dictionaryRepresentation];
            if (dictionary != nil) {
                NSDictionary *payload = @{
                                          @"name": @"SuperAwesome",
                                          @"payload": dictionary
                                          };
                
                sendToAIR(ctx, payload);
            }
        }
        
    }];
    
    return NULL;
}
