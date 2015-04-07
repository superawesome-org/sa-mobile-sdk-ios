//
//  GenericConfigurable.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 10/31/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for all the configurations for ads served by ad.com.
 *
 * @since 3.7
 */
@protocol GenericConfigurable <NSObject>

/**
 * The mobile placement identifier. This value uniquely identifies a placement that is configured server-side.
 *
 * Available in 3.1 and later.
 */
@property (nonatomic, copy) NSString *mpID;

@end
