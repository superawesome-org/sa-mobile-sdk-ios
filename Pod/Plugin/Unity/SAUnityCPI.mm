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

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

extern "C" {
    
    /**
     *  Handle CPI
     */
    void SuperAwesomeUnitySuperAwesomeHandleCPI () {
        [[SuperAwesome getInstance] handleCPI];
    }
    
}
