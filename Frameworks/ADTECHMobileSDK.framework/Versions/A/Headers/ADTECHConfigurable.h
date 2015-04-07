//
//  ADTECHConfigurable.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 10/31/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Protocol for all the configurations for ads served by ADTECH.
 *
 * @since 3.7
 */
@protocol ADTECHConfigurable <NSObject>

@required
/**
 * Holds the network id of the ad provider. This is configured on the ADTECH IQ server.
 * The default value will be loaded from the *ADTECHAdConfiguration.plist* property file upon ATBannerView creation and you can change this value anytime at runtime.
 * By changing the value at runtime you can configure different networkIDs for different ADTECH objects (ATBannerView, ATInterstitialView, ATMoviePlayerController).
 *
 * Available in 1.0 and later.
 */
@property(nonatomic,readwrite) NSUInteger networkID;

/**
 * Holds the sub-network id of the ad provider. This is configured on the Adtech IQ server.
 * The default value will be loaded from the *ADTECHAdConfiguration.plist* property file upon ATBannerView creation and you can change this value anytime at runtime.
 * By changing the value at runtime you can configure different subNetworkIDs for different ADTECH objects (ATBannerView, ATInterstitialView, ATMoviePlayerController).
 *
 * Available in 1.0 and later.
 */
@property(nonatomic,readwrite) NSUInteger subNetworkID;

/**
 * Holds the alias of a placement. The alias uniquely identifies a banner, interstitial and video ad setup within the application.
 * By default this value is *nil* making the configuration invalid and you need to programmatically specify it at runtime before the ATBannerView is loaded.
 * The server will use this value to look up and return only those ads the match the placement of the ad within the app.
 *
 * Available in 1.0 and later.
 *
 * @warning The alias is validated against nil and empty string (@""), all other values are considered valid.
 * @see See the ADTECH Mobile SDK User Guide for a better understanding of the alias.
 */
@property(nonatomic,copy) NSString *alias;

/**
 * Checks if the string passed as parameter corresponds to the SDKs valid alias template.
 * See the ADTECH Mobile SDK User Guide for a better understanding of the alias description.
 *
 * Available in 1.0 and later.
 *
 * @param anAlias The string that will be checked if it corresponds to the alias template.
 *
 * @return YES if the string matches the alias template, NO otherwise.
 *
 * @see alias
 */
- (BOOL)isValidAlias:(NSString*)anAlias;

@end
