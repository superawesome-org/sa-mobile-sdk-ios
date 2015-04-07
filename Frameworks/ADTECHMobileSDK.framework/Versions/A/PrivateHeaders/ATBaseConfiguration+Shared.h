//
//  ATBaseConfiguration+Shared.h
//  ADTECHMobileSDK
//
//  Created by Balint Dezso on 4/9/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <ADTECHMobileSDK/ATBaseConfiguration.h>

@interface ATBaseConfiguration (Shared)

+ (BOOL)liveTest;
+ (void)setLiveTest:(BOOL)enable;

+ (void)setLiveTestMock:(BOOL)enable;


+ (BOOL)isLandingPageDebugEnabled;
+ (void)setLandingPageDebugEnabled:(BOOL)enabled;

+ (void)setLandingPageDebugEnabledMock:(BOOL)enabled;

@end
