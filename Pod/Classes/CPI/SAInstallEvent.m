//
//  SAInstallEvent.m
//  Pods
//
//  Created by Gabriel Coman on 10/01/2017.
//
//

#import "SAInstallEvent.h"

// guarded imports
#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SANetworking/SANetwork.h>)
#import <SANetworking/SANetwork.h>
#else
#import "SANetwork.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/NSDictionary+SAJson.h>)
#import <SAJsonParser/NSDictionary+SAJson.h>
#else
#import "NSDictionary+SAJson.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/NSDictionary+SafeHandling.h>)
#import <SAJsonParser/NSDictionary+SafeHandling.h>
#else
#import "NSDictionary+SafeHandling.h"
#endif
#endif

#define CPI_INSTALL @"CPI_INSTALL"

@interface SAInstallEvent ()
@property (nonatomic, strong) NSUserDefaults *defs;
@end

@implementation SAInstallEvent

- (id) init {
    if (self = [super init]) {
        _defs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void) sendEvent:(SASession*) session
      withCallback:(didCountAnInstall) didCountAnInstall {
    
    // get the key for production or staging
    NSString *key = [NSString stringWithFormat:@"%@_%@",
                     CPI_INSTALL,
                     [session getConfiguration] == PRODUCTION ? @"PROD" : @"STAG"];
    
    if (![_defs objectForKey:key]) {
        
        // save this
        [_defs setObject:@(true) forKey:key];
        [_defs synchronize];
        
        // form the URL
        NSString *cpiURL = [NSString stringWithFormat:@"%@/install?bundle=%@",
                            [session getBaseUrl],
                            [session getBundleId]];
        
        // go the network part
        SANetwork *network = [[SANetwork alloc] init];
        [network sendGET:cpiURL
               withQuery:@{}
               andHeader:@{@"Content-Type":@"application/json",
                           @"User-Agent":[SAUtils getUserAgent]}
            withResponse:^(NSInteger status, NSString *payload, BOOL success) {
                
                NSDictionary *eventResponse = [[NSDictionary alloc] initWithJsonString:payload];
                BOOL eventSuccess = [eventResponse safeBoolForKey:@"success" orDefault:false];
                if (didCountAnInstall) {
                    didCountAnInstall (eventSuccess);
                }
                
            }];
        
    } else {
        NSLog(@"[AA :: Events] Already sent CPI event");
    }
    
}

@end
