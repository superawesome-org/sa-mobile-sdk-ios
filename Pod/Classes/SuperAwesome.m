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
#import "SACPI.h"

@interface SuperAwesome ()
@property (nonatomic, assign) NSInteger dauId;
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
        [SACapper enableCapping:^(NSUInteger dauId) {
            _dauId = dauId;
        }];
        [SACPI sendCPIEvent];
    }
    
    return self;
}

- (NSString*) getVersion {
    return @"5.0.2";
}

- (NSString*) getSdk {
    return @"ios";
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}

- (NSUInteger) getDAUID {
    return _dauId;
}

@end
