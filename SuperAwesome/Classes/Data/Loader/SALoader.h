//
//  SALoader.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "SANetwork.h"
#import "SALoaderProtocol.h"

// predef classes
@class SAAd;

// @brief:
// This is a loader class that acts as Master loading class
// It's main purpose if to be called either by the SDK user or by SAAd
// to perform loading and preloading of ads
//
// It can preload ads using the SALoaderProtocol and - (void) preloadAdForPlacementId:
//
// The direct ad loading functions are hidden from the user
//
@interface SALoader : NSObject

// set delegate function
+ (void) setDelegate:(id<SALoaderProtocol>) delegate;
+ (id<SALoaderProtocol>) delegate;

// laod ad function;
// does not return anything directly, but via the SALoaderProtocol delegate
+ (void) loadAdForPlacementId:(NSInteger)placementId;

@end
