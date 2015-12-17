//
//  SAVASTPlayer.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/15/2015.
//
//

#import <UIKit/UIKit.h>

// import protocol
#import "SAVASTPlayerProtocol.h"

@interface SAVASTPlayer : UIView

// protocol delegate
@property id<SAVASTPlayerProtocol> delegate;

// play or stop
- (void) playWithMediaURL:(NSURL *)url;

// reset the player
- (void) resetPlayer;

// setup the URL that gets called when clicking on a the "click button"
// can be different for each creative in an Ad
- (void) setupClickURL:(NSString*)url;

@end
