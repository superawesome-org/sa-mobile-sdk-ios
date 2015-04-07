//
//  ATVASTMediaFile.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTURL.h"
#import "ATVASTEnums.h"

typedef NS_ENUM(NSUInteger, ADTECHVASTDelivery)
{
    kATDeliveryInvalid,
    kATDeliveryStreaming,
    kATDeliveryProgressive,
};

@interface ATVASTMediaFile : ATVASTURL

@property (nonatomic, assign) ADTECHVASTDelivery delivery;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger minBitrate;
@property (nonatomic, assign) NSInteger maxBitrate;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) ATVASTTriState scalable;
@property (nonatomic, assign) ATVASTTriState maintainAspectRatio;
@property (nonatomic, copy) NSString *apiFramework;
@property (nonatomic, copy) NSString *codec;

+ (instancetype)URLWithString:(NSString*)urlString;
+ (ADTECHVASTDelivery)deliveryFromString:(NSString*)value;

@end
