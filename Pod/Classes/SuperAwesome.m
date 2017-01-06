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

#import "SACPI.h"

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
        _version = @"5.3.15";
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

- (void) handleCPI {
    [_cpi sendCPIEvent];
}

- (void) overrideVersion: (NSString*) version {
    _version = version;
}

- (void) overrideSdk: (NSString*) sdk {
    _sdk = sdk;
}

@end
