//
//  SAVASTManager.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/15/2015.
//
//

#import <Foundation/Foundation.h>

// import vast stuff
#import "SAVASTParser.h"
#import "SAVASTPlayer.h"

// import delegate
#import "SAVASTManagerProtocol.h"

@interface SAVASTManager : NSObject

// delegate
@property (nonatomic, weak) id<SAVASTManagerProtocol> delegate;

// custom init
- (id) initWithPlayer:(SAVASTPlayer*)player;

// parse VAST
- (void) parseVASTURL:(NSString*)urlString;

@end
