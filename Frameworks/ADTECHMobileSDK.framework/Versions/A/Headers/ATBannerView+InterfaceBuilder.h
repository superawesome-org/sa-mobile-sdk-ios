//
//  ATBannerView+InterfaceBuilder.h
//  ADTECHMobileSDK
//
//  Created by Zoltan Ulrich on 15.09.2014.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <ADTECHMobileSDK/ADTECHMobileSDK.h>
#import "ATBannerView.h"

/**
 * The category provides the possibility to configure a banner instance
 * from Interface Builder.
 *
 * Banners that are configured this way, automatically get a configuration
 * instance set on them, without the need to create one programmatically.
 *
 * You should not change these values in code! They are provided only
 * for Interface Builder to inspect.
 *
 * Once the banner is loaded from the storyboard or XIB, changing these
 * values has no effect on the used configuration for the banner instance.
 *
 * You can however change the values on the configuration object
 * associated with the banner instance.
 */
IB_DESIGNABLE
@interface ATBannerView(InterfaceBuilder)

// base
@property(nonatomic,copy) IBInspectable NSString *schema;
@property(nonatomic,copy) IBInspectable NSString *domain;
@property(nonatomic,assign) IBInspectable NSUInteger port;

// ad
@property(nonatomic,readwrite) IBInspectable NSUInteger groupID;
@property(nonatomic,readwrite) IBInspectable BOOL enableImageBannerResize;
@property(nonatomic,readwrite) IBInspectable BOOL hideAfterRefreshInterval;

// adtech
@property(nonatomic,readwrite) IBInspectable NSUInteger networkID;
@property(nonatomic,readwrite) IBInspectable NSUInteger subNetworkID;
@property(nonatomic,copy) IBInspectable NSString *alias;

// generic
@property (nonatomic, copy) IBInspectable NSString *mpID;

- (ATAdConfiguration*)configurationFromIB;

@end
