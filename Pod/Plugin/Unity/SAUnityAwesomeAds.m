//
//  SAUnitySuperAwesome.c
//  SuperAwesome
//
//  Created by Gabriel Coman on 13/05/2018.
//

#import "SAUnityCallback.h"
#import <SuperAwesome/SuperAwesome-Swift.h>

void SuperAwesomeUnityAwesomeAdsInit (bool loggingEnabled) {
    [AwesomeAds initSDK:loggingEnabled];
}

void SuperAwesomeUnityAwesomeAdsTriggerAgeCheck (const char *age) {
    // WARN: deprecated functionality in AA SDK
}
