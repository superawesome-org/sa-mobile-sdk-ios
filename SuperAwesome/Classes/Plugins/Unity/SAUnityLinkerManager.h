//
//  SAUnityLinkerManager.h
//  Pods
//
//  Created by Gabriel Coman on 04/02/2016.
//
//

#import <Foundation/Foundation.h>
#import "SuperAwesome.h"

@interface SAUnityLinkerManager : NSObject

// singleton instance (instead of init)
+ (SAUnityLinkerManager *)getInstance;

// setters and getters
- (void) setAd:(NSObject*)adView forKey:(NSString*)key;
- (NSObject*) getAdForKey:(NSString*)key;

@end
