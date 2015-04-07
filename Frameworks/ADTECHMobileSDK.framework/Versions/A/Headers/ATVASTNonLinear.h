//
//  ATVASTNonLinear.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import "ATVASTOverlay.h"
#import "ATVASTEnums.h"

@interface ATVASTNonLinear : ATVASTOverlay

@property (nonatomic, assign) ATVASTTriState scalable;
@property (nonatomic, assign) ATVASTTriState maintainAspectRatio;
@property (nonatomic, assign) NSTimeInterval minSuggestedDuration;
@property (nonatomic, assign) NSInteger expandedWidth;
@property (nonatomic, assign) NSInteger expandedHeight;
@property (nonatomic, copy) NSString *adParameters;
@property (nonatomic, readonly) NSMutableArray *creativeExtensions; // array of NSString objects containing any valid XML documents

@end
