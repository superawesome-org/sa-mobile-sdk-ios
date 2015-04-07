//
//  ADTECHDeviceIdentification.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 5/28/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTECHDeviceIdentification : NSObject

+ (NSString*)deviceIdentifier;

+ (BOOL)isTrackingEnabled;

@end
