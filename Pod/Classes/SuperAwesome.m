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
        [self setConfigurationProduction];
        [self disableTestMode];
        [SACapper enableCapping:^(NSUInteger dauId) {
            [[SASession getInstance] setDauId:dauId];
        }];
        
        [[SASession getInstance] setVersion:[self getSdkVersion]];
    }
    
    return self;
}

- (void) setConfiguration:(NSInteger)configuration {
    [[SASession getInstance] setConfiguration:configuration];
}

- (void) setConfigurationProduction {
    [[SASession getInstance] setConfigurationProduction];
}

- (void) setConfigurationStaging {
    [[SASession getInstance] setConfigurationStaging];
}

- (void) setTesting:(BOOL)enabled {
    [[SASession getInstance] setTest:enabled];
}

- (void) disableTestMode {
    [[SASession getInstance] setTestDisabled];
}

- (void) enableTestMode {
    [[SASession getInstance] setTestEnabled];
}

- (NSString*) getVersion {
    return @"4.3.10";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}
- (NSString*) getBaseURL {
    return [[SASession getInstance] getBaseUrl];
}
- (BOOL) isTestingEnabled {
    return [[SASession getInstance] isTestEnabled];
}
- (NSInteger) getConfiguration {
    return [[SASession getInstance] getConfiguration];
}
- (NSUInteger) getDAUID {
    return [[SASession getInstance] getDauId];
}

@end
