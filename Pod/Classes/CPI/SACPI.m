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

@interface SACPI ()
@property (nonatomic, strong) NSUserDefaults *defs;
@end

@implementation SACPI

- (id) init {
    if (self = [super init]) {
        _defs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void) sendCPIEvent {
    
    if (![_defs objectForKey:CPI_INSTALL]) {

        NSLog(@"[AA :: Events] Sending CPI event");
        
        // form the URL
        NSString *cpiURL = [NSString stringWithFormat:@"https://ads.staging.superawesome.tv/v2/install?bundle=%@",
                            [[NSBundle mainBundle] bundleIdentifier]];
        
        // use saevent to send CPI event
        SAEvents *events = [[SAEvents alloc] init];
        [events sendEventToURL:cpiURL];
        [_defs setObject:@(true) forKey:CPI_INSTALL];
        [_defs synchronize];
    } else {
        NSLog(@"[AA :: Events] Already sent CPI event");
    }
}

@end
