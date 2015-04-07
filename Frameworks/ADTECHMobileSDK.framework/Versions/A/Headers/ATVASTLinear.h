//
//  ATVASTLinear.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTTrackable.h"   
#import "ATVASTEnums.h"


extern const NSTimeInterval AT_VAST_INVALID_DURATION;

@class ATVASTVideoClicks;
@class ATVASTTracking;

@interface ATVASTLinear : ATVASTTrackable

@property (nonatomic, readonly) NSMutableArray *icons; // array of Icon
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) NSString *adParameters;
@property (nonatomic, copy) NSString *skipOffset;
@property (nonatomic, strong) ATVASTVideoClicks *videoClicks;
@property (nonatomic, readonly) NSMutableArray *mediaFiles; // array of ATVASTMediaFile
@property (nonatomic, readonly) NSMutableArray *creativeExtensions; // array of NSString objects containing any valid XML documents

@end
