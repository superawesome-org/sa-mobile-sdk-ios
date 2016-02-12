//
//  SuperAwesome.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import header
#import "SuperAwesome.h"

// define the three URL constants
#define BASE_URL_STAGING @"https://ads.staging.superawesome.tv/v2"
#define BASE_URL_DEVELOPMENT @"https://ads.dev.superawesome.tv/v2"
#define BASE_URL_PRODUCTION @"https://ads.superawesome.tv/v2"
#define SUPER_AWESOME_DAU_ID @"SUPER_AWESOME_DAU_ID"

@interface SuperAwesome ()

// private vars
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, strong) NSString *dauID;
@property (nonatomic, assign) SAConfiguration config;

@end

@implementation SuperAwesome

+ (SuperAwesome *)getInstance {
    static SuperAwesome *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil){
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype) init {
    if (self = [super init]) {
        // by default configuration is set to production
        // and test mode is disabled
        [self setConfigurationProduction];
        [self disableTestMode];
        [self enableDeviceAppUserId];
    }
    
    return self;
}

- (NSString*) getVersion {
    return @"3.4.8";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@",
            [[SuperAwesome getInstance] getSdk],
            [[SuperAwesome getInstance] getVersion]];
}

- (void) setConfigurationProduction {
    _config = PRODUCTION;
    _baseURL = BASE_URL_PRODUCTION;
}

- (void) setConfigurationStaging {
    _config = STAGING;
    _baseURL = BASE_URL_STAGING;
}

- (void) setConfigurationDevelopment {
    _config = DEVELOPMENT;
    _baseURL = BASE_URL_DEVELOPMENT;
}

- (SAConfiguration) getConfiguration {
    return _config;
}

- (NSString*) getBaseURL {
    return _baseURL;
}

- (void) enableTestMode {
    _isTestEnabled = true;
}

- (void) disableTestMode {
    _isTestEnabled = false;
}

- (void) setTesting:(BOOL)enabled {
    _isTestEnabled = enabled;
}

- (BOOL) isTestingEnabled {
    return _isTestEnabled;
}

// generates a unique per device / per app / per user ID
// that is COPPA compliant
- (NSString*) generateId {
    // constants
    const NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    const NSInteger length = [alphabet length];
    const NSInteger dauLength = 32;
    
    // create the string
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < dauLength; i++) {
        u_int32_t r = arc4random() % length;
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return s;
}

- (void) enableDeviceAppUserId {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *dauID = [def objectForKey:SUPER_AWESOME_DAU_ID];
    if (!dauID || [dauID isEqualToString:@""]){
        dauID = [self generateId];
        [def setObject:dauID forKey:SUPER_AWESOME_DAU_ID];
        [def synchronize];
        _dauID = dauID;
    } else {
        _dauID = dauID;
    }
}

- (NSString*) getDAUID {
    return _dauID;
}


@end
