//
//  ATVASTInLineAndWrapperBase.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTEnums.h"

@class ATVASTAdSystem;

@interface ATVASTInLineAndWrapperBase : NSObject

@property (nonatomic, strong) ATVASTAdSystem *adSystem;
@property (nonatomic, readonly) NSMutableArray *errors; // array of NSURL objects
@property (nonatomic, readonly) NSMutableArray *impressions; // array of ATVASTURL objects
@property (nonatomic, readonly) NSMutableArray *creatives; // array of ATVASTCreative objects
@property (nonatomic, readonly) NSMutableArray *extensions; // array of NSString objects containing any valid XML documents
@property (nonatomic, readonly) NSMutableArray *adtechProprietaryExtensions;

- (NSArray*)creativesOfType:(ATVASTCreativeType)type;

@end
