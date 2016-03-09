//
//  SuperAwesome.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import "MPBannerCustomEvent.h"

// This class extends MoPub's own MPBannerCustomEvent and is used
// as a seamless bridge between SuperAwesome and MoPub
//
// Using this bridge Super Awesome Banner Ads can be displayed in your app,
// using MoPub's SDK (so you don't have to use SuperAwesome ad sdk)
//
// Visit documentation at https://dev.twitter.com/mopub/network-mediation/custom-unsupported-ios
// to learn more about integrating this into your iOS App
@interface SuperAwesomeBannerCustomEvent : MPBannerCustomEvent
@end
