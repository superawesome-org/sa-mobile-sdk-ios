//
//  SATokenResponse.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 07/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "JSONModel.h"
#import "SAUser.h"

@interface SATokenResponse : JSONModel

@property (nonatomic,strong) SAUser *user;

@end
