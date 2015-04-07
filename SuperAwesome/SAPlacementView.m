//
//  SAPlacement.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 01/12/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SAPlacementView.h"
#import "SuperAwesome.h"

@implementation SAPlacementView : UIView

- (void)setAppID:(NSString *)appID
{
    _appID = appID;
}

- (ATAdtechAdConfiguration *)configurationWithNetworkId:(NSUInteger)networkId subNetworkId:(NSUInteger)subNetworkId alias:(NSString *)alias
{
    ATAdtechAdConfiguration *configuration = [ATAdtechAdConfiguration configuration];
    configuration.networkID = networkId;
    configuration.subNetworkID = subNetworkId;
    configuration.alias = alias;
    return configuration;
}

- (ATAdtechAdConfiguration *)configurationWithDisplayAd:(SADisplayAd *)displayAd
{
    NSUInteger networkID = [displayAd.networkId unsignedIntegerValue];
    NSUInteger subNetworkID = [displayAd.subNetworkId unsignedIntegerValue];
    NSString *alias = displayAd.alias;
    return [self configurationWithNetworkId:networkID subNetworkId:subNetworkID alias:alias];
}

@end
