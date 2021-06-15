//
//  SAUnitySuperAwesome.c
//  SuperAwesome
//
//  Created by Gabriel Coman on 13/05/2018.
//

#import <UIKit/UIKit.h>
#import "SAUnityCallback.h"

extern "C" {
    void SuperAwesomeUnityAwesomeAdsInit (bool loggingEnabled) {
        [AwesomeAds initSDK:loggingEnabled];
    }
    
    void SuperAwesomeUnityAwesomeAdsTriggerAgeCheck (const char *age) {
        // WARN: deprecated functionality in AA SDK
    }
}
