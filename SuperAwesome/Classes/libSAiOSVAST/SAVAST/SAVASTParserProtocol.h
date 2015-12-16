//
//  SAVASTParserProtocol.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/14/2015.
//
//

#import <UIKit/UIKit.h>

//
// @brief: The SAVASTParserProtocol implements two functions
@protocol SAVASTParserProtocol <NSObject>

//
// @brief: called as a callback when there are valid ads to be displayed
- (void) didParseVASTAndHasAdsResponse:(NSArray*)ads;

//
// @brief: called as a callback when there are no valid ads to be displayed
- (void) didNotFindAnyValidAds;

//
// @brief: this should be called when the VAST response is entirely corrupted
// for one reason or another
- (void) didFindInvalidVASTResponse;

@end