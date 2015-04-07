//
//  NSURL+ATLandingPage.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 10/25/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The available types of URLs from opening behavior perspective.
 * When opened, some URLs will show a in-app web page, some will triggered switching to another application, some will show you a new screen inside your application.
 *
 * @since 3.4.
 */

typedef NS_ENUM(NSUInteger, ATLandingPageURLType)
{
	/** URLs that don't conform to WebURL, NativeURL or InAppURL. */
	kATUnknownURL,
	
    /** URLs that will take you to a web page. */
    kATInAppWebPageURL,
    
    /** URLs that will switch to another app, like Phone, Messages, Mail, etc, and put your app in the background. */
    kATExternalAppURL,
	
	/** URLs that will show an inApp ViewController, like an AppStore URL that will show SKStoreProductViewController on iOS 6.0 or greater. */
    kATInAppScreenURL,
};


/**
 * This category over NSURL can be used to check the URL type.
 *
 * @since 3.4
 */
@interface NSURL (ATLandingPage)

/**
 * Call this method to check what type of URL is the current one.
 *
 * @return The URL type.
 *
 * @since 3.4
 */
- (ATLandingPageURLType)landingPageURLType;

@end
