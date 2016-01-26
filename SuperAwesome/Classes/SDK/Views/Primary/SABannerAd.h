//
//  SAHalfscreenView.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

// import base class
#import "SAView.h"

// forward declaration of SAWebView, a special subclass of WebView that
// is used by Ads to display all kinds of content
@class SAWebView;

// @brief:
// The SABannerAd class can hold any type of image or rich media ad
// It's a simple implementation over SKMRAIDView
@interface SABannerAd : SAView

- (void) resizeToFrame:(CGRect)toframe;

@end
