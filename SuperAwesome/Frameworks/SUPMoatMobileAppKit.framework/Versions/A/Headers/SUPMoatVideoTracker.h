//
//  MoatVideoAPI.h
//  WebView
//
//  Created by alex on 2/20/15.
//  Copyright (c) 2015 Moat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SUPMoatBootstrap.h"

@interface SUPMoatVideoTracker : SUPMoatBootstrap

@property bool debug;

+ (SUPMoatVideoTracker *)trackerWithPartnerCode:(NSString*)partnerCode;

- (bool) trackVideoAd:(NSDictionary*)adIds
   usingMPMoviePlayer:(MPMoviePlayerController*)player;

- (bool) trackVideoAd:(NSDictionary*)adIds
   usingAVMoviePlayer:(AVPlayer*)player
            withLayer:(CALayer*)layer
   withContainingView:(UIView*)view;

- (void) dispatchEvent:(NSDictionary*)options;

- (void) changeTargetLayer:(CALayer*)newLayer
        withContainingView:(UIView*)view;

@end
