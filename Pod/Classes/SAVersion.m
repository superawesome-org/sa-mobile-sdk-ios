//
//  SAVersion.m
//  Pods
//
//  Created by Gabriel Coman on 26/07/2017.
//
//

#import "SAVersion.h"

static NSString *version    = @"8.3.3";
static NSString *sdk        = @"ios";

@implementation SAVersion

+ (NSString*) getPluginName {
#if ADMOB_PLUGIN
    return @"_admob";
#else
    return @"";
#endif
}

+ (NSString*) getSdkVersion {
    return [NSString stringWithFormat:@"%@_%@%@", sdk, version, [self getPluginName]];
}

+ (void) overrideVersion: (NSString*) v {
    version = v;
}

+ (void) overrideSdk: (NSString*) s {
    sdk = s;
}

@end
