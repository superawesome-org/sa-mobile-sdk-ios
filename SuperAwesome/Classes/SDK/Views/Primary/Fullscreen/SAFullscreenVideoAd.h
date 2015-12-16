//
//  SAFullscreenVideoAd.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 21/10/2015.
//
//

#import "SAViewController.h"
#import "SAVideoAdProtocol.h"

// @brief:
// The SAFullscreenVideo Ad is just a ViewController that loads a SAVideoAd
// object in its ViewDidLoad method
@interface SAFullscreenVideoAd : SAViewController

// video delegate
@property id<SAVideoAdProtocol> videoDelegate;

@end
