//
//  ATVideoAdConfiguration.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 5/10/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATBaseConfiguration.h"
#import "ATVideoAdOverlay.h"
#import "ATCloseIndicator.h"

/**
 * The available ad type to be presented during playback of video content
 */
typedef NS_OPTIONS(NSUInteger, ATVideoAdType)
{
    /// Ads to be shown before playback of content starts
    kATVideoAdPreRoll = 1 << 0,
    
    /// Ads to be shown at some point during the playback of the content
    kATVideoAdMidRoll = 1 << 1,
    
    /// Ads to be shown at the end of playback of the content
    kATVideoAdPostRoll = 1 << 2,
    
    /// Overlay ads to be shown during content playback
    kATVideoAdOverlay = 1 << 3,
    
    /**
     * Companion ad for the bottom position to be requested with linear ads.
     * Companion ads can be used only in conjunction with a linear ad.
     *
     * @since 3.4
     */
    kATVideoAdCompanionBottom = 1 << 4,
    
    /**
     * Companion ad for the top position to be requested with linear ads.
     * Companion ads can be used only in conjunction with a linear ad.
     *
     * @since 3.4
     */
    kATVideoAdCompanionTop = 1 << 5,
    
    /**
     * Companion ad for the left position to be requested with linear ads.
     * Companion ads can be used only in conjunction with a linear ad.
     *
     * @since 3.4
     */
    kATVideoAdCompanionLeft = 1 << 6,
    
    /**
     * Companion ad for the right position to be requested with linear ads.
     * Companion ads can be used only in conjunction with a linear ad.
     *
     * @since 3.4
     */
    kATVideoAdCompanionRight = 1 << 7,
};

/**
 * Holds the base configuration for video ads shown by ATMoviePlayerController.
 * You create an instance of a specialized subclass of this object and set on it the needed values in order to receive and show video ads from a placement you have configured server side.
 * Set the configuration object on the ATMoviePlayerController that you use, once it is configured.
 * If you change the configuration while already playing video content, the changes will take effect only when fetching new ads.
 * For ads served by ADTECH use ATAdtechVideoAdConfiguration
 * For ads served by AdapTV use ATAdapTVVideoAdConfiguration
 *
 * @since 2.2
 *
 * @see ATAdtechVideoAdConfiguration
 * @see ATAdapTVVideoAdConfiguration
 */
@interface ATVideoAdConfiguration : ATBaseConfiguration

/**
 * The optional desired size for the video ads. If set, a video of exact size is requested.
 * Defaults to CGSizeZero.
 *
 * @since 2.2
 */
@property (nonatomic, assign) CGSize videoDimension;

/**
 * The optional desired video ad length. If set, matching video length will be smaller or equal to the specified value.
 * Defaults to 0.
 *
 * @since 2.2
 */
@property (nonatomic, assign) NSTimeInterval videoLength;

/**
 * The optional video ad bitrate in kbps. If set, only a video of exactly the same bitrate can match.
 *
 * @since 2.2
 */
@property (nonatomic, assign) NSUInteger videoBitrate;

/**
 * The optional video ad type. If set, only a video of exactly the same type can match.
 * Possible values are: image-gif, image-jpg, image-png, video-asf, video-avi, video-mov, video-mpg, video-mkv, video-wmv, video-ra, video-mp4,
 * although not all of these might be supported by the platform you are running the application on. Only one value can be used at one time.
 *
 * @since 3.2.1
 */
@property (nonatomic, copy) NSString *videoType;

/**
 * The array of configured overlays to show during content playback.
 *
 * @since 2.2
 */
@property (nonatomic, readonly, copy) NSArray *overlays;

/**
 * The maximum number of times wrapper redirections will be followed until reaching an actual inline video ad.
 * For an understanding of what a wrapper is, please consult the IAB VAST documentation.
 * The default value is 3. If you don't know and don't care about this value then leave it unchanged.
 *
 * @since 2.2
 */
@property (nonatomic, assign) NSUInteger maxWrapperRedirections;

/** 
 * By checking this property you can see if the configuration is valid or not. For validity the following properties are checked: _hostApplicationName, domain, alias_
 * E.g. You can use this property to make sure that the configuration is correctly set up before playing the ATMoviePlayerController object.
 *
 * @since 2.2
 */
@property(nonatomic, readonly) BOOL isValid;

/**
 * Allows overriding the default close indicator for skippable linear ads and overlays after the countdown timer. If this value is not set,
 * the SDK uses its own image resources that can be found in SDK's bundle.
 *
 * If you want to use your own images, you must set the properties found in ATCloseIndicator interface. Currently these properties
 * are used only for two control states: UIControlStateNormal and UIControlStateHighlighted.
 *
 * @since 3.4
 *
 * @see ATCloseIndicator
 */
@property(nonatomic,strong) ATCloseIndicator *closeIndicator;

/**
 * Allows overriding the default indicator for overlay's countdown timer. If this value is not set, the SDK uses its own
 * image resources that can be found in SDK's bundle.
 *
 * If you want to use your own images, you must set the properties found in ATCloseIndicator interface. Currently these properties
 * are used only for two control states: UIControlStateNormal and UIControlStateHighlighted.
 *
 * @since 3.4
 *
 * @see ATCloseIndicator
 */
@property(nonatomic,strong) ATCloseIndicator *countdownIndicator;

/**
 * When enabled, the SDK will show a countdown overlay on top of linear ads showing the remaining time
 * until the ad finishes playing. By default, the countdown is not enabled.
 *
 * The default countdown shows a text and the number of minutes and seconds, following a the format:
 * "Ad: $mm:$ss". Using the ADTECHLocalizable.strings file, you can change the format to one better
 * suited to your app. The SDK will look for the $mm and $ss macros to replace them with the minutes
 * and the seconds respectively. If the time left is less than a minute only the seconds are displayed
 * (the $mm macro or the $mm: construct, i.e. $mm followed by a colon, is replaced with the empty string).
 *
 * @since 3.5.1
 */
@property(nonatomic,assign) BOOL linearAdCountdownEnabled;

/**
 * Enables presentation of the video ad type specified as parameter, if not already enabled.
 * If you want, for example, to have a pre-roll with a companion-bottom shown, you should
 * call this method twice: once with 'kATVideoAdPreRoll' as type and once with 'kATVideoAdCompanionBottom'.
 *
 * @param type The type of ad to enable for this configuration instance.
 * 
 * @since 2.2
 */
- (void)enableAdType:(ATVideoAdType)type;

/**
 * Disables presentation of the video ad type specified as parameter, if it was enabled.
 *
 * @param type The type of ad to disable for this configuration instance.
 *
 * @since 2.2
 */
- (void)disableAdType:(ATVideoAdType)type;

/**
 * Checks if presentation of the video ad type specified as parameter is enabled or not.
 *
 * @param type The type of ad to check for this configuration instance.
 * @return YES if the specified ad type is enabled. NO if not.
 *
 * @since 2.2
 */
- (BOOL)isAdTypeEnabled:(ATVideoAdType)type;

/**
 * Adds a new overlay to be shown during content playback.
 *
 * @param overlay A configured instance of an overlay to be shown
 * @see overlays
 * @see removeOverlay:
 *
 * @note Changing the overlays during playback will take effect only after the video is restarted.
 *
 * @since 2.2
 */
- (void)addOverlay:(ATVideoAdOverlay*)overlay;

/**
 * Removes an overlay from the array of overlays to be shown during playback.
 *
 * @param overlay The overlay instance to be removed
 * @see overlays
 * @see addOverlay:
 *
 * @note Changing the overlays during playback will take effect only after the video is restarted.
 *
 * @since 2.2
 */
- (void)removeOverlay:(ATVideoAdOverlay*)overlay;

@end
