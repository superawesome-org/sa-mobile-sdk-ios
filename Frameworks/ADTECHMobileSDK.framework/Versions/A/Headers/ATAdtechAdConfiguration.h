//
//  ATAdtechAdConfiguration.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 1/21/13.
//  Copyright (c) 2013 ADTECH AG. All rights reserved.
//

#import <ADTECHMobileSDK/ADTECHMobileSDK.h>
#import "ATAdConfiguration.h"
#import "ADTECHConfigurable.h"
/**
 * Holds the specific configuration of ads served by ADTECH. You can set here the placement identification details.
 * Default values are loaded from the ADTECHAdConfiguration.plist file when you create a new instance of the configuration.
 *
 * You can find the ADTECHAdConfiguration.plist in the Resources folder of the SDK framework. You'll need to manually include it in your application.
 * The ADTECHAdConfiguration.plist comes with preset values and you can change them to your convenience.
 *
 * Available in 3.1 and later.
 *
 * @see ATAdConfiguration
 * @see ATBaseConfiguration
 * @see ADTECHConfigurable
 * @see [ATBannerView configuration]
 * @see [ATInterstitialView configuration]
 */
@interface ATAdtechAdConfiguration : ATAdConfiguration<NSCopying, ADTECHConfigurable>
{
}

/**
 * Creates a new autoreleased instance of the configuration. This is a convenience method.
 * The configuration values will be loaded from the configuration file (ADTECHAdConfiguration.plist).
 *
 * Available in 3.1 and later.
 */
+ (ATAdtechAdConfiguration*)configuration;

@end
