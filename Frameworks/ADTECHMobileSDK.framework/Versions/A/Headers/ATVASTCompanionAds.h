//
//  ATVASTCompanionAds.h
//  ADTECHMobileSDK
//
//  Created by Balint Dezso on 4/24/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTEnums.h"


@interface ATVASTCompanionAds : NSObject

@property (nonatomic, readonly) NSMutableArray *companions; // array of ATVASTCompanion objects
@property (nonatomic, assign) ATVASTCompanionDisplayRequirement required;

- (id)init;
- (id)initWithRequiredAttribute:(NSString *)required;

@end
