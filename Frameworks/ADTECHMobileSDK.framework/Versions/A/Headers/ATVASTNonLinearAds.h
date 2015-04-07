//
//  ATVASTNonLinearAds.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTEnums.h"
#import "ATVASTTrackable.h"

@class ATVASTTracking;

@interface ATVASTNonLinearAds : ATVASTTrackable

@property (nonatomic, readonly) NSMutableArray *nonLinears; // array of ATVASTNonLinear objects



@end
