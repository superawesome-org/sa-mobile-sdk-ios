//
//  ATBrowserViewController.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 10/11/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Subclass this class to have your own ViewController shown when opening landing pages.
 *
 * @since 3.4
 */
@interface ATBrowserViewController : UIViewController

/**
 * Call this method on 'super' when you want to close your browser.
 *
 * @warning: If you don't call this method, the SDK won't know that it should resume its internal processes and this can lead to side effects.
 *
 * @since 3.4
 */
- (void)close;

@end
