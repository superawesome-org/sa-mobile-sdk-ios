//
//  ATVASTWrapper.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/19/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTInLineAndWrapperBase.h"

@interface ATVASTWrapper : ATVASTInLineAndWrapperBase

@property (nonatomic, copy) NSURL *VASTAdTagURI;
@property (nonatomic) BOOL followAdditionalWrappers;
@property (nonatomic) BOOL allowMultipleAds;
@property (nonatomic) BOOL fallBackOnNoAd;

@end
