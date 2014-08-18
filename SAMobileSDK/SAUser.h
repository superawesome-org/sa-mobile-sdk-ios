//
//  SAUser.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 07/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "JSONModel.h"

@interface SAUser : JSONModel

@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSNumber *points;
@property (nonatomic,strong) NSNumber *total_points_received;
@property (nonatomic,strong) NSString *appToken;

@end
