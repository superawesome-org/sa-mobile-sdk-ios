//
//  ATVASTProprietaryExtension.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 5/14/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTEnums.h"

@interface ATVASTProprietaryExtension : NSObject

@property (nonatomic, assign) ATVASTProprietaryExtensionType type;
@property (nonatomic, copy) NSString *value;

+ (ATVASTProprietaryExtensionType)typeForString:(NSString*)typeValue;

@end
