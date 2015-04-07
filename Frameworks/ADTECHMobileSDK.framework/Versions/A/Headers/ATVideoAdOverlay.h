//
//  ATVideoAdOverlay.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 5/24/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The placement of an overlay relative to the video view
 * Available in 2.2 and later.
 */
typedef NS_ENUM(NSUInteger, ATVideoAdOverlayPlacement)
{
    /// Bottom of the video view
    kATOverlayPlacementBottom,
    
    /// Top of the video view
    kATOverlayPlacementTop,
    
    /// Left of the video view
    kATOverlayPlacementLeft,
    
    /// Right of the video view
    kATOverlayPlacementRight,
};

/**
 * The dismiss policy of the overlay
 * Available in 2.2 and later.
 */
typedef NS_ENUM(NSInteger, ATVideoAdOverlayDismissTime)
{
    /// The default policy: overlay is dismissable after being presented for 50% of duration
    kATOverlayDismissDefault = -2,
    
    /// The overlay is not allowed to be dismissed
    kATOverlayDismissNotAllowed = -1,
    
    /// The overlay is dismissable from the moment it started being shown
    kATOverlayDismissAllowedFromBeginning = 0,
};

/**
 * Defines the configuration for one overlay (non-linear) ad to be shown during content playback.
 * For each overlay you want shown during content playback, you create an instance of this class,
 * configure it and add it to the ATMoviePlayerController configuration.
 *
 * Available in 2.2 and later.
 */
@interface ATVideoAdOverlay : NSObject
{
    NSTimeInterval startTime;
    NSTimeInterval duration;
    
    ATVideoAdOverlayPlacement placement;
    NSInteger percentOfMargin;
    
    NSInteger secondsUntilDismissable;
}

/// The number of seconds of content playback to show the overlay after.
/// The period of time during which the content is paused or scrubbed through will be subtracted and won't count towards showing the overlay.
/// i.e. Only actual playback of content is tracked and can trigger the appearance of the overlay.
///
/// Version 3.6 made the default value be 5 seconds.
///
/// Available in 2.2 and later.
@property (nonatomic, assign) NSTimeInterval startTime;

/// Time interval the overlay should be displayed for, in seconds.
/// Version 3.6 made the default value be INFINITY (i.e. the whole duration of the content).
///
/// Available in 2.2 and later.
@property (nonatomic, assign) NSTimeInterval duration;

/// The region of the video player view to show the overlay on.
/// Possible values are: kATOverlayPlacementBottom, kATOverlayPlacementTop, kATOverlayPlacementLeft, kATOverlayPlacementRight.
/// The default value is kATOverlayPlacementBottom.
///
/// Available in 2.2 and later.
@property (nonatomic, assign) ATVideoAdOverlayPlacement placement;

/// The percent of margin to allow from the selected edge through the placement.
/// The value must in the range 0 to 100.
/// e.g. Setting a value of 10 with the placement value kATOverlayPlacementBottom will place the overlay at 10% of the video player height from the bottom edge.
/// The set value is normalized to be in the allowed range. The default value is 0.
///
/// Available in 2.2 and later.
@property (nonatomic, assign) NSInteger percentOfMargin;

/// The number of seconds to wait from the moment the overlay is shown until it is allowed being dismissed.
/// If you want the overlay to be dismissable from the start, use the kATOverlayDismissAllowedFromBeginning constant.
/// If you want the overlay to never be dismissable (for the duration of it being shown), use the kATOverlayDismissNotAllowed constant.
/// If you set a value greater or equal to the duration, it will count as kATOverlayDismissNotAllowed.
/// If the default value (kATOverlayDissmisDefault) is left in place, the overlay will be dismissable after half of the duration.
///
/// Version 3.6 changed the default value to kATOverlayDismissAllowedFromBeginning.
///
/// Available in 2.2 and later.
@property (nonatomic, assign) NSInteger secondsUntilDismissable;

/**
 * Convenience method to create an overlay with startTime and duration.
 *
 * Available in 2.2 and later.
 *
 * @param startTime The initial value for the startTime property.
 * @param duration The initial value for the duration property.
 * @return An overlay instance with having the values specified for duration and startTime.
 */
+ (ATVideoAdOverlay*)overlayWithStartTime:(NSTimeInterval)startTime andDuration:(NSTimeInterval)duration;

@end
