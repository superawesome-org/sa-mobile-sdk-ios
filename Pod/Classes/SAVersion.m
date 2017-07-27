//
//  SAVersion.m
//  Pods
//
//  Created by Gabriel Coman on 26/07/2017.
//
//

#import "SAVersion.h"

static NSString *version    = @"5.7.2";
static NSString *sdk        = @"ios";

@implementation SAVersion

+ (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@", sdk, version];
}

+ (void) overrideVersion: (NSString*) v {
    version = v;
}

+ (void) overrideSdk: (NSString*) s {
    sdk = s;
}

@end
