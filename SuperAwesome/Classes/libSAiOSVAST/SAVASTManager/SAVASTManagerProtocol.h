//
//  SAVASTManagerProtocol.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/15/2015.
//
//

#import <Foundation/Foundation.h>

//
// @brief: functions used by the Manager to send out info
@protocol SAVASTManagerProtocol <NSObject>

@optional

//
// @brief: called when the VAST data is parsed, is valid and ads that
// can be played have been found
- (void) didParseVASTAndFindAds;

//
// @brief: called when the VAST data is parsed, is valid but no ads that
// can be played have been found
- (void) didParseVASTButDidNotFindAnyAds;

//
// @brief: called when the VAST data could not be parsed at all
- (void) didNotParseVAST;

//
// @brief: called when an Ad from a group of Ads has just started playing
- (void) didStartAd;

//
// @brief: called when a creative from the current Ad has started playing
- (void) didStartCreative;

//
// @brief: called when 1/4 of a creative's length has passed
- (void) didReachFirstQuartileOfCreative;

//
// @brief: called when 1/2 of a creative's length has passed
- (void) didReachMidpointOfCreative;

//
// @brief: called when 3/4 of a creative's length has passed
- (void) didReachThirdQuartileOfCreative;

//
// @brief: called when a creative from the current Ad has finished playing
- (void) didEndOfCreative;

//
// @brief: called when a creative could not be played (due to corrupt
// resource on the network, wifi problems, etc)
- (void) didHaveErrorForCreative;

// @brief: called when an ad has played all its creatives
- (void) didEndAd;

// @brief: called when all ads and all creative have played
- (void) didEndAllAds;

@end
