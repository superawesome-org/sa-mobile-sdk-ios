//
//  SAUnitySuperAwesome.c
//  SuperAwesome
//
//  Created by Gabriel Coman on 13/05/2018.
//

#import <UIKit/UIKit.h>
#import "SAUnityCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesome.h>)
#import <SuperAwesomeSDK/SuperAwesome.h>
#else
#import "SuperAwesome.h"
#endif
#endif

extern "C" {
    
    void SuperAwesomeUnityInit (bool loggingEnabled) {
        [SuperAwesome initSDK:loggingEnabled];
    }
    
    void SuperAwesomeUnityTriggerAgeCheck (const char *age) {
        
        NSString *ageString = [NSString stringWithUTF8String:age];
        
        [SuperAwesome triggerAgeCheck:ageString response:^(GetIsMinorModel *model) {
         
         if (model != nil) {
            NSDictionary *payload = [model dictionaryRepresentation];
            if (payload != nil) {
                sendToUnity(@"SuperAwesome", payload);
            }
         }
        }];
    }
}
