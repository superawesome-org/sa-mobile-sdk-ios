//
//  SuperAwesome.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 29/07/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SuperAwesome.h"
#import "SKLogger.h"

@interface SuperAwesome ()

@end

@implementation SuperAwesome

+ (SuperAwesome *)sharedManager
{
    static SuperAwesome *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil){
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype)init
{
    if(self = [super init]){
        _adManager = [[SAAdManager alloc] init];
        [self setClientConfiguration:SAClientConfigurationProduction];
    }
    return self;
}

- (NSString*) getVersion {
    return @"2.1.7";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@",
            [[SuperAwesome sharedManager] getSdk],
            [[SuperAwesome sharedManager] getVersion]];
}


- (void)setClientConfiguration:(SAClientConfiguration)clientConfiguration
{
    _clientConfiguration = clientConfiguration;
    
    if(self.clientConfiguration == SAClientConfigurationProduction){
        self.adManager.baseURL = @"https://ads.superawesome.tv/v2";
        [self setLoggingLevel:SALoggingLevelWarning];
    }else if(self.clientConfiguration == SAClientConfigurationStaging){
        self.adManager.baseURL = @"https://staging.beta.ads.superawesome.tv/v2";
        [self setLoggingLevel:SALoggingLevelDebug];
    }else{
        self.adManager.baseURL = @"https://dev.ads.superawesome.tv/v2";
        [self setLoggingLevel:SALoggingLevelDebug];
    }
}

- (void)setTestModeEnabled:(BOOL)testModeEnabled
{
    _testModeEnabled = testModeEnabled;
    self.adManager.testModeEnabled = testModeEnabled;
}

- (void)setLoggingLevel:(SALoggingLevel)loggingLevel
{
    _loggingLevel = loggingLevel;
    
    switch (loggingLevel) {
        case SALoggingLevelNone:
            [SKLogger setLogLevel:SourceKitLogLevelNone];
            break;
        case SALoggingLevelError:
            [SKLogger setLogLevel:SourceKitLogLevelError];
            break;
        case SALoggingLevelWarning:
            [SKLogger setLogLevel:SourceKitLogLevelWarning];
            break;
        case SALoggingLevelInfo:
            [SKLogger setLogLevel:SourceKitLogLevelInfo];
            break;
        case SALoggingLevelDebug:
            [SKLogger setLogLevel:SourceKitLogLevelDebug];
            break;
        default:
            break;
    }
    
}


@end
