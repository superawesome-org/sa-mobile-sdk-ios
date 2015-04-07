//
//  ATVASTInLine.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/19/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTInLineAndWrapperBase.h"

@class ATVASTPrice;
@class ATVASTAdSystem;
@class ATVASTCreative;

@interface ATVASTInLine : ATVASTInLineAndWrapperBase

@property (nonatomic, copy) NSString *adTitle;
@property (nonatomic, copy) NSString *inLineDescription;
@property (nonatomic, copy) NSString *advertiser;
@property (nonatomic, copy) NSURL *survey;
@property (nonatomic, strong) ATVASTPrice *pricing;

- (ATVASTCreative *)creativeMatchingCreative:(ATVASTCreative *)creativeToMatch atIndex:(NSUInteger)index;

@end
