//
//  SALoaderUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 18/01/2016.
//
//

#import <Foundation/Foundation.h>

// callback for generic success with data
typedef void (^loadingEvent)(NSString *unityAd, NSString *unityCallback, NSString *adString);

@interface SALoaderUnityLinker : NSObject

// main loading function for the linker
- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString*)unityAd
   withTestMode:(BOOL)isTestEnabled;

@property (nonatomic, assign) loadingEvent event;

@end
