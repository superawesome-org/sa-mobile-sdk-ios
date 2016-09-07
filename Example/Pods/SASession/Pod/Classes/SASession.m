//
//  SASession.m
//  Pods
//
//  Created by Gabriel Coman on 15/07/2016.
//
//

#import "SASession.h"

#define CONFIGURATION_PRODUCTION 0
#define CONFIGURATION_STAGING 1

#define PRODUCTION_URL @"https://ads.superawesome.tv/v2"
#define STAGING_URL @"https://ads.staging.superawesome.tv/v2"

@interface SASession ()
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, assign) BOOL testEnabled;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) NSInteger dauId;
@property (nonatomic, assign) NSInteger configuration;
@end

@implementation SASession

- (id) init {
    if (self = [super init]) {
        [self setConfigurationProduction];
        [self setTestDisabled];
        [self setDauId:0];
        [self setVersion:@"0.0.0"];
    }
    return self;
}

+ (NSInteger) getProductionConfigurationID {
    return 0;
}

+ (NSInteger) getStatingConfigurationID {
    return 1;
}

// setters

- (void) setConfiguration:(NSInteger) configuration {
    if (configuration == CONFIGURATION_PRODUCTION) {
        [self setConfigurationProduction];
    } else {
        [self setConfigurationStaging];
    }
}

- (void) setConfigurationProduction {
    _configuration = CONFIGURATION_PRODUCTION;
    _baseUrl = PRODUCTION_URL;
}

- (void) setConfigurationStaging {
    _configuration = CONFIGURATION_STAGING;
    _baseUrl = STAGING_URL;
}

- (void) setTestEnabled {
    _testEnabled = true;
}

- (void) setTestDisabled {
    _testEnabled = false;
}

- (void) setTest:(BOOL) testEnabled {
    _testEnabled = testEnabled;
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

- (BOOL) isTestEnabled {
    return _testEnabled;
}

- (NSInteger) getDauId {
    return _dauId;
}

- (NSString*) getVersion {
    return _version;
}

- (NSInteger) getConfiguration {
    return _configuration;
}


@end
