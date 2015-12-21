//
//  SAVideoAdProtocol.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 20/10/2015.
//
//

#import <UIKit/UIKit.h>

// @brief:
// This is the SAVideoProtocol implementation, that defines a series of
// functions that might be of interest to SDK users who want to have specific
// actions in case of video events
@protocol SAVideoAdProtocol <NSObject>

// all functions are optional
@optional

// fired when an ad has started
- (void) adStarted:(NSInteger)placementId;

// fired when a video ad has started
- (void) videoStarted:(NSInteger)placementId;

// fired when a video ad has reached 1/4 of total duration
- (void) videoReachedFirstQuartile:(NSInteger)placementId;

// fired when a video ad has reached 1/2 of total duration
- (void) videoReachedMidpoint:(NSInteger)placementId;

// fired when a video ad has reached 3/4 of total duration
- (void) videoReachedThirdQuartile:(NSInteger)placementId;

// fired when a video ad has ended
- (void) videoEnded:(NSInteger)placementId;

// fired when an ad has ended
- (void) adEnded:(NSInteger)placementId;

// fired when all ads have ended
- (void) allAdsEnded:(NSInteger)placementId;

@end
