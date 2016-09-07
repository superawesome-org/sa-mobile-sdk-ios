

//
//  SACPI.m
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "SACPI.h"
#import "SAEvents.h"
#import "SASession.h"

#define CPI_INSTALL @"CPI_INSTALL"

@implementation SACPI

+ (void) sendCPIEvent {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:CPI_INSTALL]) {
        
        // form the URL
        NSMutableString *cpiURL = [@"" mutableCopy];
        [cpiURL appendFormat:@"https://ads.staging.superawesome.tv/v2"];
        [cpiURL appendString:@"/install?bundle="];
        [cpiURL appendFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]];
        
        // use saevent to send CPI event
        [SAEvents sendEventToURL:cpiURL];
        [def setObject:@(true) forKey:CPI_INSTALL];
        [def synchronize];
        
    } else {
        // already sent this event
    }
}

@end