//
//  ATAdapTVVideoAdConfiguration.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 9/11/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import "ATVideoAdConfiguration.h"

/**
 * Holds the placement configuration for video ads shown by ATMoviePlayerController that are served by AdapTV.
 * You create an instance of this object and set on it the needed values in order to receive and show video ads from a placement you have configured server side.
 * Set the configuration object on the ATMoviePlayerController that you use, once it is configured.
 * If you change the configuration while already playing video content, the changes will take effect only when fetching new ads.
 *
 * Available in 3.6
 */
@interface ATAdapTVVideoAdConfiguration : ATVideoAdConfiguration<NSCopying>

/**
 * Holds the campaign identifier that corresponds to a valid Adap.tv campaign
 * By default this value is *nil* making the configuration invalid and you need to programmatically specify it at runtime before the ATMoviePlayerController is loaded.
 * The server will use this value to look up and return only those ads the match the placement of the ad within the app.
 *
 * Available in 3.6
 *
 * @warning The adapTVCampaign must be a valid URL or the configuration will be not be valid
 *          See the ADTECH Mobile SDK User Guide for a better understanding of the adapTVCampaign.
 */

@property(nonatomic,copy) NSString *campaign;

/**
 * Creates a new autoreleased instance of the configuration. This is a convenience method.
 * The configuration default values will be loaded from the configuration file (ADTECHAdConfiguration.plist).
 *
 * Available in 3.6
 */
+ (ATAdapTVVideoAdConfiguration*)configuration;

@end
