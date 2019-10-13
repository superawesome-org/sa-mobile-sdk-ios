//
//  SAMockSession.m
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 10/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAMockSession.h"

@implementation SAMockSession

- (NSString *)getAppName {
    return @"SAAdLoaderDemo";
}

- (NSString *)getBaseUrl {
    return @"http://localhost:64000";
}

- (NSString *)getBundleId {
    return @"superawesome.tv.saadloaderdemo";
}

- (NSInteger)getCachebuster {
    return 123456;
}

- (SAConfiguration)getConfiguration {
    return PRODUCTION;
}

- (NSInteger)getConnectivityType {
    return 2;
}

- (NSUInteger)getDauId {
    return 654321;
}

- (NSString *)getDevice {
    return @"phone";
}

- (NSInteger)getHeight {
    return 50;
}

- (SARTBInstl)getInstl {
    return IN_FULLSCREEN;
}

- (NSString *)getLang {
    return @"en_US";
}

- (SARTBPlaybackMethod)getPlaybackMethod {
    return PB_WITH_SOUND_ON_SCREEN;
}

- (SARTBPosition)getPos {
    return POS_FULLSCREEN;
}

- (SARTBSkip)getSkip {
    return SK_NO_SKIP;
}

- (SARTBStartDelay)getStartDelay {
    return DL_PRE_ROLL;
}

- (BOOL)getTestMode {
    return true;
}

- (NSString *)getUserAgent {
    return @"some-user-agent";
}

- (NSString *)getVersion {
    return @"1.0.0";
}

- (NSInteger)getWidth {
    return 320;
}

@end
