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
@end

@implementation SASession

+ (instancetype) getInstance {
    static SASession *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init {
    if (self = [super init]) {
        _baseUrl = PRODUCTION_URL;
        _testEnabled = false;
        _version = @"0.0.0";
        _dauId = 0;
    }
    return self;
}

// setters

- (void) setConfigurationProduction {
    _baseUrl = PRODUCTION_URL;
}

- (void) setConfigurationStaging {
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


@end
