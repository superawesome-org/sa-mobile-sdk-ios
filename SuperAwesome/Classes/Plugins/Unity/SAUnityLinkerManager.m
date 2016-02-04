//
//  SAUnityLinkerManager.m
//  Pods
//
//  Created by Gabriel Coman on 04/02/2016.
//
//

#import "SAUnityLinkerManager.h"

@interface SAUnityLinkerManager ()

// a dictionary of ads
@property (nonatomic, strong) NSMutableDictionary *adsDictionary;

@end

@implementation SAUnityLinkerManager

+ (SAUnityLinkerManager *)getInstance {
    static SAUnityLinkerManager *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil){
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

- (instancetype) init {
    if (self = [super init]) {
        // init the mutable dictionary
        _adsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) setAd:(NSObject *)adView forKey:(NSString *)key {
    [_adsDictionary setObject:adView forKey:key];
}

- (NSObject*) getAdForKey:(NSString *)key {
    return [_adsDictionary objectForKey:key];
}

@end
