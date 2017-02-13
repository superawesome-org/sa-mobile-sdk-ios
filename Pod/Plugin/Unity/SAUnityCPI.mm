//
//  SAUnityCPI.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2017.
//
//

#import <UIKit/UIKit.h>
#import "SAUnityCallback.h"

#if defined(__has_include)
#if __has_include("SuperAwesomeSDKUnity.h")
#import "SuperAwesomeSDKUnity.h"
#else
#import "SuperAwesome.h"
#endif
#endif

extern "C" {
    
    /**
     * Unity to native iOS method that sends a CPI event.
     */
    void SuperAwesomeUnitySACPIHandleCPI () {
        
        [[SACPI getInstance] sendInstallEvent:^(BOOL success) {
            
            sendCPICallback(@"SAUnityCPI", success, @"HandleCPI");
            
        }];
        
    }
}
