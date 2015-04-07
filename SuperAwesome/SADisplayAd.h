//
//  SAAdPlacement.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 21/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@protocol SADisplayAd
@end

@interface SADisplayAd : JSONModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *networkId;
@property (nonatomic,strong) NSNumber<Optional> *subNetworkId;
@property (nonatomic,strong) NSString *alias;
@property (nonatomic,strong) NSNumber *mediaTypeId;
@property (nonatomic,strong) NSNumber *sizeTypeId;
@property (nonatomic,strong) NSNumber *width;
@property (nonatomic,strong) NSNumber *height;

- (CGSize)size;

@end
