//
//  SALoaderUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 18/01/2016.
//
//

#import <Foundation/Foundation.h>
#import "SAUnityLinkerCallbacks.h"

@interface SALoaderUnityLinker : NSObject

// main loading function for the linker
- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString*)unityAd
   withTestMode:(BOOL)isTestEnabled;

@property (nonatomic, assign) loadingEvent event;

@end
