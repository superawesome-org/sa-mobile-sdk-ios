//
//  ATVASTTracking.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTEnums.h"

@interface ATVASTTracking : NSURL

@property (nonatomic, assign) ATVASTTrackingEvent event;
@property (nonatomic, copy) NSString *offset;

+ (ATVASTTracking*)trackingWithURLString:(NSString*)url andEvent:(NSString*)eventValue;
+ (ATVASTTrackingEvent)eventFromString:(NSString*)value;

@end
