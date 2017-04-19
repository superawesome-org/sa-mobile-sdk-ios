/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SuperAwesome.h"

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

@interface SuperAwesome ()
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

/**
 * Private constructor that is only called once
 */
- (id) init {
    if (self = [super init]) {
        _version = @"5.5.8";
        _sdk = @"ios";
    }
    
    return self;
}

/**
 * Getter for the current version
 *
 * @return string representing the current version
 */
- (NSString*) getVersion {
    return _version;
}

/**
 * Getter for the current SDK
 *
 * @return string representing the current SDK
 */
- (NSString*) getSdk {
    return _sdk;
}

- (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", [self getSdk], [self getVersion]];
}

- (void) overrideVersion: (NSString*) version {
    _version = version;
}

- (void) overrideSdk: (NSString*) sdk {
    _sdk = sdk;
}

@end
