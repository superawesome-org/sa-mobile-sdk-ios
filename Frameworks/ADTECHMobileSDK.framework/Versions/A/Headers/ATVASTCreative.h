//
//  ATVASTCreative.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/19/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATVASTLinear;
@class ATVASTNonLinearAds;
@class ATVASTCompanionAds;
@class ATVASTCompanion;
@class ATVASTNonLinear;

@interface ATVASTCreative : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger sequence;
@property (nonatomic, copy) NSString *adID;
@property (nonatomic, copy) NSString *apiFramework;

@property (nonatomic, strong) ATVASTLinear *linear;
@property (nonatomic, strong) ATVASTCompanionAds *companionAds;
@property (nonatomic, strong) ATVASTNonLinearAds *nonLinearAds;

- (BOOL)containsResource;
- (ATVASTCompanion *)companionMatching:(ATVASTCompanion *)companionToMatch atIndex:(NSUInteger)index;
- (ATVASTNonLinear *)nonLinearMatching:(ATVASTNonLinear *)nonLinearToMatch atIndex:(NSUInteger)index;

- (ATVASTCreativeType)type;

@end
