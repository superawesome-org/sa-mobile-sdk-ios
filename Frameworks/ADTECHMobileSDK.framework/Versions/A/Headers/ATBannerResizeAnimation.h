//
//  ATBannerResizeAnimation.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 03.10.2013.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATConfigurationConstants.h"

/**
 * Describes the parameters to use when performing an ad resizing.
 *
 * @since 3.4.
 */
@interface ATBannerResizeAnimation : NSObject <NSCopying>

/// The behavior to use when resizing the ad
///
/// @since 3.4.
@property (assign, nonatomic) ResizeBehavior behavior;

/// How long should the animation take, in seconds?
///
/// @since 3.4.
@property (assign, nonatomic) NSTimeInterval duration;

/// How long should starting the animation be delayed, in seconds?
///
/// @since 3.4.
@property (assign, nonatomic) NSTimeInterval delay;

/// When running on iOS 7 or higher, this value is passed into the animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion: API.
/// On iOS 6 or earlier it has no effect.
///
/// @since 3.4.
@property (assign, nonatomic) CGFloat springWithDampingRatio;

/// When running on iOS 7 or higher, this value is passed into the animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion: API.
/// On iOS 6 or earlier it has no effect.
///
/// @since 3.4.
@property (assign, nonatomic) CGFloat initialSpringVelocity;

/// The animation options as a combination of flags
///
/// @since 3.4.
@property (assign, nonatomic) UIViewAnimationOptions options;

/// The block to perform when starting the animation
///
/// @since 3.4.
@property (strong, nonatomic) void (^animations)(void);

/// The block to perform when the animation has ended
///
/// @since 3.4.
@property (strong, nonatomic) void (^completion)(void);

@end
