//
//  SAUnityCPI.c
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
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

#import "SAUnityCallback.h"

extern "C" {
    
    void SuperAwesomeUnitySuperAwesomeHandleCPI () {
        
        [[SuperAwesome getInstance] handleCPI:^(BOOL success) {
            
            sendCPICallback(@"SuperAwesomeCPI", success, @"HandleCPI");
            
        }];
        
    }
    
    void SuperAwesomeUnitySuperAwesomeHandleStagingCPI () {
        
        [[SuperAwesome getInstance] handleStagingCPI:^(BOOL success) {
            
            sendCPICallback(@"SuperAwesomeCPI", success, @"HandleStagingCPI");
            
        }];
        
    }
    
}
