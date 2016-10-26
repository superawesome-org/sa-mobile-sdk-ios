//
//  SASession.m
//  Pods
//
//  Created by Gabriel Coman on 15/07/2016.
//
//

#import "SASession.h"
#import "SACapper.h"
#import "SAUtils.h"

#define PRODUCTION_URL @"https://ads.superawesome.tv/v2"
#define STAGING_URL @"https://ads.staging.superawesome.tv/v2"

#define DEVICE_PHONE @"phone"
#define DEVICE_TABLET @"tablet";

@interface SASession ()
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, assign) BOOL testEnabled;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) NSInteger dauId;
@property (nonatomic, assign) SAConfiguration configuration;
@property (nonatomic, strong) NSString *bundleId;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, assign) NSInteger connectivityType;
@property (nonatomic, strong) NSString *userAgent;
@end

@implementation SASession

- (id) init {
    if (self = [super init]) {
        // set config, testing, version - things that may change
        [self setConfigurationProduction];
        [self disableTestMode];
        [self setVersion:@"0.0.0"];
        
        // get the bundle id, app name, etc, things that might not change
        _bundleId = [[NSBundle mainBundle] bundleIdentifier];
        _appName = [SAUtils encodeURI:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
        _device = [SAUtils getSystemSize] == size_phone ? DEVICE_PHONE : DEVICE_TABLET;
        _userAgent = [SAUtils getUserAgent];
        
        _lang = @"none";
        NSArray *languages = [NSLocale preferredLanguages];
        if ([languages count] > 0) {
            _lang = [[languages firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];;
        }
        
        
        // get the Dau Id
        SACapper *capper = [[SACapper alloc] init];
        [self setDauId:[capper getDauId]];
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

- (NSString*) getBundleId {
    return _bundleId;
}

- (NSString*) getAppName {
    return _appName;
}

- (NSString*) getLang {
    return _lang;
}

- (NSString*) getDevice {
    return _device;
}

- (NSInteger) getConnectivityType {
    return _connectivityType;
}

- (NSInteger) getCachebuster {
    return [SAUtils getCachebuster];
}

- (NSString*) getUserAgent {
    return _userAgent;
}

@end
