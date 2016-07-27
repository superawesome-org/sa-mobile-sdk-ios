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
#import "SASession.h"

@interface SuperAwesome ()
@property (nonatomic, assign) SAConfiguration config;
@end

@implementation SuperAwesome

+ (instancetype) getInstance {
    static SuperAwesome *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init {
    if (self = [super init]) {
        // by default configuration is set to production
        // and test mode is disabled
        [self setConfigurationProduction];
        [self disableTestMode];
        [SAEvents enableSATracking];
        [SACapper enableCapping:^(NSUInteger dauId) {
            [[SASession getInstance] setDauId:dauId];
        }];
        
        // set loader session instance
        [[SASession getInstance] setVersion:[self getSdkVersion]];
    }
    
    return self;
}

- (NSString*) getVersion {
    return @"4.3.6";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}

- (void) setConfigurationProduction {
    _config = PRODUCTION;
    [[SASession getInstance] setConfigurationProduction];
}

- (void) setConfigurationStaging {
    _config = STAGING;
    [[SASession getInstance] setConfigurationStaging];
}

- (SAConfiguration) getConfiguration {
    return _config;
}

- (NSString*) getBaseURL {
    return [[SASession getInstance] getBaseUrl];
}

- (void) enableTestMode {
    [[SASession getInstance] setTest:true];
}

- (void) disableTestMode {
    [[SASession getInstance] setTest:false];
}

- (void) setTesting:(BOOL)enabled {
    [[SASession getInstance] setTest:enabled];
}

- (BOOL) isTestingEnabled {
    return [[SASession getInstance] isTestEnabled];
}

- (NSUInteger) getDAUID {
    return [[SASession getInstance] getDauId];
}

@end
