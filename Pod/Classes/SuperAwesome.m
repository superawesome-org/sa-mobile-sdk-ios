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

// guarded imports
#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

@interface SuperAwesome ()
@property (nonatomic, strong) SACPI *cpi;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *sdk;
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
        _cpi = [[SACPI alloc] init];
        _version = @"5.3.16";
        _sdk = @"ios";
    }
    
    return self;
}

- (NSString*) getVersion {
    return _version;
}

- (NSString*) getSdk {
    return _sdk;
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}

- (void) handleCPI:(didCountAnInstall)didCountAnInstall {
    SASession *session = [[SASession alloc] init];
    [session setConfigurationProduction];
    [_cpi sendInstallEvent:session withCallback:didCountAnInstall];
}

- (void) handleStagingCPI:(didCountAnInstall)didCountAnInstall {
    SASession *session = [[SASession alloc] init];
    [session setConfigurationStaging];
    [_cpi sendInstallEvent:session withCallback:didCountAnInstall];
}

- (void) overrideVersion: (NSString*) version {
    _version = version;
}

- (void) overrideSdk: (NSString*) sdk {
    _sdk = sdk;
}

@end
