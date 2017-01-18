//
//  SAAIRCallback.h
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

void sendAdCallback (FREContext context, NSString *name, int placementId, NSString *callback);
void sendCPICallback (FREContext context, NSString *name, BOOL success, NSString *callack);
