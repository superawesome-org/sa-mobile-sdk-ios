//
//  ATCloseIndicator.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 10/9/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Allows overriding the default close indicator for expanded ads, interstitials and video ads.
 * If you want to use your own images as close indicators, provide them through this configuration object.
 *
 * @since 3.4.
 *
 * @see ATBaseConfiguration
 */
@interface ATCloseIndicator : NSObject

/**
 * The image to be used for the UIControlStateNormal state of the indicator button.
 * Defaults to nil, meaning the SDK should use its own resource for the indicator.
 *
 * @since 3.4.
 */
@property (nonatomic,copy) UIImage *normalStateImage;

/**
 * The image to be used for the UIControlStateHighlighted state of the indicator button.
 * Defaults to nil, meaning the SDK should use its own resource for the indicator.
 *
 * @since 3.4.
 */
@property (nonatomic,copy) UIImage *highlightedStateImage;

@end
