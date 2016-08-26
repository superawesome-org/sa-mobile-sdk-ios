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
#import "SAUtils.h"

// predef classes
@class SAAd;

// callback
typedef void (^didLoadAd)(SAAd *ad);

// class
@interface SALoader : NSObject

/**
 *  Method that loads an ad async
 *
 *  @param placementId the placement id
 *  @param result      the result callback
 */
- (void) loadAd:(NSInteger)placementId withResult:(didLoadAd)result;

@end
