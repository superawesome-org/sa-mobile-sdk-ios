//
//  SALoaderUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 18/01/2016.
//
//

#import <Foundation/Foundation.h>

// callback for generic success with data
typedef void (^successEvent)(NSString *unityAd, NSString *adString);
typedef void (^errorEvent)(NSString *unityAd, NSInteger placementId);

@interface SALoaderUnityLinker : NSObject

// main loading function for the linker
- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString*)unityAd
   withTestMode:(BOOL)isTestEnabled;

@property (nonatomic, assign) successEvent success;
@property (nonatomic, assign) errorEvent error;

@end
