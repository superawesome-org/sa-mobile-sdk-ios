//
//  SuperAwesomeRewardedVideoCustomEvent.h
//  SAMoPubIntegrationDemo
//
//  Created by Gabriel Coman on 17/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "MPRewardedVideoCustomEvent.h"

// This class extends MoPub's own MPRewardedVideoCustomEvent and is used
// as a seamless bridge between SuperAwesome and MoPub
//
// Using this bridge Super Awesome Banner Ads can be displayed in your app,
// using MoPub's SDK (so you don't have to use SuperAwesome ad sdk)
//
// Visit documentation at https://dev.twitter.com/mopub/network-mediation/custom-unsupported-ios
// to learn more about integrating this into your iOS App
@interface SuperAwesomeRewardedVideoCustomEvent : MPRewardedVideoCustomEvent

@end
