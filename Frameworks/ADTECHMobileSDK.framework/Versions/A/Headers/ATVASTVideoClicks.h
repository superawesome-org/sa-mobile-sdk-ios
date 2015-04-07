//
//  ATVASTVideoClicks.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATVASTURL;

@interface ATVASTVideoClicks : NSObject

@property (nonatomic, copy) ATVASTURL *clickThrough;
@property (nonatomic, readonly) NSMutableArray *clickTracking; // array of ATVASTURL
@property (nonatomic, readonly) NSMutableArray *customClick; // array of ATVASTURL

@end
