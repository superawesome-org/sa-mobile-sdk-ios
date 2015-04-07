//
//  ATVASTIcon.h
//  ADTECHMobileSDK
//
//  Created by Balint Dezso on 4/22/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <ADTECHMobileSDK/ADTECHMobileSDK.h>

@interface ATVASTIcon : ATVASTOverlay

@property (nonatomic, readonly) NSMutableArray *iconViewTracking;
@property (nonatomic, copy) NSString *program;
@property (nonatomic, copy) NSString *xPosition;
@property (nonatomic, copy) NSString *yPosition;
@property (nonatomic, assign) NSTimeInterval offset;
@property (nonatomic, assign) NSTimeInterval duration;

@end
