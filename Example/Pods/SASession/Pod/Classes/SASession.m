//
//  SASession.m
//  Pods
//
//  Created by Gabriel Coman on 15/07/2016.
//
//

#import "SASession.h"

#define PRODUCTION_URL @"https://ads.superawesome.tv/v2"
#define STAGING_URL @"https://ads.staging.superawesome.tv/v2"

@interface SASession ()
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, assign) BOOL testEnabled;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) NSInteger dauId;
@property (nonatomic, assign) SAConfiguration configuration;
@end

@implementation SASession

- (id) init {
    if (self = [super init]) {
        [self setConfigurationProduction];
        [self disableTestMode];
        [self setDauId:0];
        [self setVersion:@"0.0.0"];
    }
    return self;
}

- (void) setConfiguration:(SAConfiguration) configuration {
    if (configuration == PRODUCTION) {
        _configuration = PRODUCTION;
        _baseUrl = PRODUCTION_URL;
    } else {
        _configuration = STAGING;
        _baseUrl = STAGING_URL;
    }
}

- (void) setConfigurationProduction {
    [self setConfiguration:PRODUCTION];
}

- (void) setConfigurationStaging {
    [self setConfiguration:STAGING];
}

- (void) setTestMode:(BOOL)testEnabled {
    _testEnabled = testEnabled;
}

- (void) enableTestMode {
    [self setTestMode:true];
}

- (void) disableTestMode {
    [self setTestMode:false];
}


- (void) setDauId:(NSInteger)dauId {
    _dauId = dauId;
}

- (void) setVersion:(NSString *)version {
    _version = version;
}

// getters

- (NSString*) getBaseUrl {
    return _baseUrl;
}

- (BOOL) getTestMode {
    return _testEnabled;
}

- (NSInteger) getDauId {
    return _dauId;
}

- (NSString*) getVersion {
    return _version;
}

- (SAConfiguration) getConfiguration {
    return _configuration;
}


@end
