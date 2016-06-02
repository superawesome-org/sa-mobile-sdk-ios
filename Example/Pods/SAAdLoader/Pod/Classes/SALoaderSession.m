//
//  SALoaderSession.m
//  Pods
//
//  Created by Gabriel Coman on 02/06/2016.
//
//

#import "SALoaderSession.h"

#define URL_KEY @"baseURL"
#define DAU_KEY @"dauID"
#define TST_KEY @"testingEnabled"
#define VER_KEY @"version"

#define URL_DEF @"https://ads.superawesome.tv/v2"
#define DAU_DEF @(0)
#define TST_DEF @(false)
#define VER_DEF @"0"

@interface SALoaderSession ()
@property (nonatomic, strong) NSMutableDictionary *sessionData;
@end

@implementation SALoaderSession

+ (SALoaderSession *) getInstance {
    static SALoaderSession *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil){
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype) init {
    if (self = [super init]) {
        _sessionData = [@{
            URL_KEY: URL_DEF,
            DAU_KEY: DAU_DEF,
            TST_KEY: TST_DEF,
            VER_KEY: VER_DEF
        } mutableCopy];
    }
    return self;
}

- (void) setBaseUrl:(NSString*)baseUrl {
    [_sessionData setObject:baseUrl forKey:URL_KEY];
}

- (void) setDauId:(NSInteger)dauId {
    [_sessionData setObject:@(dauId) forKey:DAU_KEY];
}

- (void) setTest:(BOOL)test {
    [_sessionData setObject:@(test) forKey:TST_KEY];
}

- (void) setVersion:(NSString*)version {
    [_sessionData setObject:version forKey:VER_KEY];
}

- (NSString*) getBaseUrl {
    return _sessionData[URL_KEY];
}

- (NSNumber*) getDauId {
    return _sessionData[DAU_KEY];
}

- (NSNumber*) getTest {
    return _sessionData[TST_KEY];
}

- (NSString*) getVersion {
    return _sessionData[VER_KEY];
}

@end
