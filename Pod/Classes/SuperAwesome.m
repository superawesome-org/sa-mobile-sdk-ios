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

// import the SACapper part
#import "SACapper.h"
#import "SAEvents.h"
#import "SALoaderSession.h"

// define the three URL constants
#define BASE_URL_STAGING @"https://ads.staging.superawesome.tv/v2"
#define BASE_URL_DEVELOPMENT @"https://ads.dev.superawesome.tv/v2"
#define BASE_URL_PRODUCTION @"https://ads.superawesome.tv/v2"

@interface SuperAwesome ()

// private vars
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, assign) NSUInteger dauID;
@property (nonatomic, assign) SAConfiguration config;

@end

@implementation SuperAwesome

+ (SuperAwesome *) getInstance {
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
        NSLog(@"What's up?");
        // by default configuration is set to production
        // and test mode is disabled
        [self setConfigurationProduction];
        [self disableTestMode];
        [SAEvents enableSATracking];
        [SACapper enableCapping:^(NSUInteger dauId) {
            _dauID = dauId;
        }];
        
        // set loader session instance
        [[SALoaderSession getInstance] setVersion:[self getSdkVersion]];
        [[SALoaderSession getInstance] setDauId:_dauID];
    }
    
    return self;
}

- (NSString*) getVersion {
    return @"4.2.5";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}

- (void) setConfigurationProduction {
    _config = PRODUCTION;
    _baseURL = BASE_URL_PRODUCTION;
    [[SALoaderSession getInstance] setBaseUrl:_baseURL];
}

- (void) setConfigurationStaging {
    _config = STAGING;
    _baseURL = BASE_URL_STAGING;
    [[SALoaderSession getInstance] setBaseUrl:_baseURL];
}

- (void) setConfigurationDevelopment {
    _config = DEVELOPMENT;
    _baseURL = BASE_URL_DEVELOPMENT;
    [[SALoaderSession getInstance] setBaseUrl:_baseURL];
}

- (SAConfiguration) getConfiguration {
    return _config;
}

- (NSString*) getBaseURL {
    return _baseURL;
}

- (void) enableTestMode {
    _isTestEnabled = true;
    [[SALoaderSession getInstance] setTest:_isTestEnabled];
}

- (void) disableTestMode {
    _isTestEnabled = false;
    [[SALoaderSession getInstance] setTest:_isTestEnabled];
}

- (void) setTesting:(BOOL)enabled {
    _isTestEnabled = enabled;
    [[SALoaderSession getInstance] setTest:_isTestEnabled];
}

- (BOOL) isTestingEnabled {
    return _isTestEnabled;
}

- (NSUInteger) getDAUID {
    return _dauID;
}

@end
