//
//  VideoAdUnityWrapper.h
//  SuperAwesome
//
//  Created by Gabriel Coman on 08/06/2019.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SACallback.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoAdUnityWrapper : NSObject

- (void) load: (NSInteger) placementId;
- (void) play: (NSInteger) placementId fromViewController: (UIViewController*)vc;
- (void) setCallback:(sacallback)callback;

@end

NS_ASSUME_NONNULL_END
