//
//  NSString+ADTECHLogging.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 07.10.2013.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADTECHMobileSDK/ATConfigurationConstants.h>

@interface NSString (ADTECHLogging)

+ (NSString*)stringFromResizeBehavior:(ResizeBehavior)behavior;

@end
