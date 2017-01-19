/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAInstallEvent.h"

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

// define a key to save data to in user defaults
#define CPI_INSTALL @"CPI_INSTALL"

@interface SAInstallEvent ()
@property (nonatomic, strong) NSUserDefaults *defs;
@end

@implementation SAInstallEvent

/**
 * Custom overridden init that gets an instance of the standard user defaults
 */
- (id) init {
    if (self = [super init]) {
        _defs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void) sendEvent:(SASession*) session
      withCallback:(saDidCountAnInstall) response {
    
    // get the key for production or staging
    NSString *key = [NSString stringWithFormat:@"%@_%@",
                     CPI_INSTALL,
                     [session getConfiguration] == PRODUCTION ? @"PROD" : @"STAG"];
    
    // only if the event hasn't yet been sent
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
                if (response) {
                    response (eventSuccess);
                }
                
            }];
        
    } else {
        NSLog(@"[AA :: Events] Already sent CPI event");
    }
    
}

@end
