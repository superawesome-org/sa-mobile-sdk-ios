//
//  SAVersion.m
//  Pods
//
//  Created by Gabriel Coman on 26/07/2017.
//
//

#import "SAVersion.h"

static NSString *version    = @"7.2.11";
static NSString *sdk        = @"ios";

@implementation SAVersion

+ (NSString*) getPluginName {
#if MOPUB_PLUGIN
    return @"_mopub";
#elif ADMOB_PLUGIN
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
