//
//  SAVASTPlayerProtocol.h
//  TestVASTParser
//
//  Created by Gabriel Coman on 15/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// @protocol for the SAVASTPlayer
@protocol SAVASTPlayerProtocol <NSObject>

//
// @brief: player ready
- (void) didFindPlayerReady;

//
// @brief: called when the player starts
- (void) didStartPlayer;

//
// @brief: called when the player reaches 1/4 of playing time
- (void) didReachFirstQuartile;

//
// @brief: called when the player reaches 1/2 of playing time
- (void) didReachMidpoint;

//
// @brief: called when the player reaches 3/4 of playing time
- (void) didReachThirdQuartile;

//
// @brief: called when the player reaches the end of playing time
- (void) didReachEnd;

//
// @brief: called when the player terminates with error
- (void) didPlayWithError;

@end
