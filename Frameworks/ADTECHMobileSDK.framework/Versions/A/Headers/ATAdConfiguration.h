//
//  ATAdConfiguration.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 11/9/11.
//  Copyright (c) 2011 ADTECH AG. All rights reserved.
//
//  www.adtech.com 
//

#import <Foundation/Foundation.h>
#import "ATBaseConfiguration.h"

#import "ATCloseIndicator.h"

/**
 * Holds the base configuration for banner and interstitial ads. You can set here different parameters for the ad's behavior.
 * Default values are loaded from the ADTECHAdConfiguration.plist file when the ATBannerView gets created.
 *
 * The placement identifying details can be set on the concrete configuration instances ATAdtechAdConfiguration or ATGenericAdConfiguration
 * that inherit from this class.
 *
 * You can find the ADTECHAdConfiguration.plist in the Resources folder of the SDK framework. You'll need to manually include it in your application.
 * The ADTECHAdConfiguration.plist comes with preset values and you can change them to your convenience.
 *
 * Available in 1.0 and later.
 *
 * @see ATBaseConfiguration
 * @see ATAdtechAdConfiguration
 * @see ATGenericAdConfiguration
 * @see [ATBannerView configuration]
 */
@interface ATAdConfiguration : ATBaseConfiguration
{
    NSUInteger groupID;
    
    BOOL allowLocationServices;
    BOOL enableImageBannerResize;
}

/** 
 * Holds the group id of the ATBannerView. This is used to solve tilling and companion situations where two or more ads should show ads relative to each other.
 * ATBannerView objects having the same groupID will be treated in a special manner by the ad server in the sense that they will be servered ads that depend on each other or complete each other.
 * Setting it to 0 will signal that the ATBannerView does not belong to any group. Default is 0.
 * The value of the number does not matter, but what matters is the fact that two or more ATBannerView objects have the same groupID.
 * E.g. If you have 2 ATBannerView objects on the same page that shouls show companion ads, you need to set them the same groupID (not 0). It does not matter that is 100 or 234 as far as both ATBannerView objects have the same value set.
 * See the ADTECH Mobile SDK User Guide for a better undestanding of Tilling and Companion.
 *
 * Available in 1.0 and later.
 */
@property(nonatomic,readwrite) NSUInteger groupID;

/** 
 * By checking this property you can see if the configuration is valid or not. For validity the following properties are checked: _alias, domain_
 * E.g. You can use this property to make sure that the configuration is correctly set up before calling the load methon on the ATBannerView object.
 *
 * Available in 1.0 and later.
 *
 * @see [ATBannerView load]
 */
@property(nonatomic,readonly) BOOL isValid;

/**
 * You can allow ADTECH ads to use your location by settings this value to YES.
 * By default, location services are disabled for ADTECH ads. Enabling location services will allow for richer, more engaging ads.
 *
 * Available in 2.0 and later.
 * @deprecated
 */
@property(nonatomic,readwrite) BOOL allowLocationServices __attribute__ ((deprecated));

/**
 * Allows or disallows banner auto-resizing to the actual image size received for simple image ads.
 * For example, when enabled, if a banner is set to have the initial size of {320, 50} and a simple image ad is received of size {240, 40},
 * the ad will resize itself to {240, 40}. If the next image ad content is {320, 50}, the ad resizes itself again to {320, 50}.
 * When enabled, the ad view adapts its size to the actual size of the simple image ad received. Mediated ads do not trigger resizing.
 *
 * The resizing takes place the same way it does for resizable rich media ads, informing the application of the beginning and end of the
 * process through the resize callbacks available through ATBannerViewDelegate.
 *
 * Default value is NO.
 *
 * Available in 2.2.1 and later.
 */
@property(nonatomic,readwrite) BOOL enableImageBannerResize;

/**
 * When set to YES, the banner will hide itself after the first refresh interval passes. If you want to load a new ad,
 * call load on the banner and set the banner to not be hidden. The recommended place to do that is inside the
 * didFetchNextAd: callback on the delegate.
 *
 * Default value is NO.
 *
 * Available in 3.1 and later.
 *
 * @warning Be sure to set the hidden property back to NO on the banner if you want to show another ad.
 *
 * @see [ATBannerView load]
 * @see [ATBannerViewDelegate didFetchNextAd:]
 */
@property(nonatomic,readwrite) BOOL hideAfterRefreshInterval;

/**
 * Set this property with the extensions of the file types you want cached.
 * By default, media files (audio and video files, identified by extension) are not cached for rich media ads.
 * By providing here an array of extensions, you are instructing the SDK to additionally cache any media file with
 * the extension found in this array.
 *
 * @warning Be sure to add only NSString type objects.
 *
 * @since 3.4
 */
@property(nonatomic,copy,readwrite) NSArray *cacheableMediaExtensions;

/**
 * Allows overriding the default close indicator for expanded ads and interstitials. If this value is not set, the SDK uses its own
 * image resources that can be found in SDK's bundle.
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
 * Returns the domain URL used when showing the location permission from within an ad.
 * The default value is @"http://adtech.com"
 *
 * @note    iOS shows a location permission alert for web views that ask for location through HTML5 API
 *          even if the application already received permission for location for its own uses (through CoreLocation).<br/><br/>
 *          Instead of the app name, this alert shows the base URL of the content loaded in the web view.
 *          Since the base URL for ads is normally a folder inside the application bundle, the path to it is not what users
 *          and application developers are expecting to see.<br/><br/>
 *          To address this, the SDK will show the domain URL returned by this method instead of the local path.
 *          The value should be a well formed URL, using the http or https scheme.
 *
 * @see setDomainURLForLocationPermission:
 * @since 3.5.4
 */
+ (NSURL*)domainURLForLocationPermission;

/**
 * Use this method to change the value for the domain URL shown in the permission alert for location usage from within ad web views.
 *
 * @param domainURL A well formed URL with a supported network based scheme (http or https)
 *
 * @see domainURLForLocationPermission
 * @since 3.5.4
 */
+ (void)setDomainURLForLocationPermission:(NSURL *)domainURL;

@end
