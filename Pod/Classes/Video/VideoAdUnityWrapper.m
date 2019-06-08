//
//  VideoAdUnityWrapper.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 08/06/2019.
//

#import "VideoAdUnityWrapper.h"

#if defined(__has_include)
#if __has_include(<SuperAwesome/SuperAwesome-Swift.h>)
#import <SuperAwesome/SuperAwesome-Swift.h>
#else
#import "SuperAwesome-Swift"
#endif
#endif

@implementation VideoAdUnityWrapper

- (void) load:(NSInteger)placementId {
    [SAVideoAd load:placementId];
}

- (void) play:(NSInteger)placementId fromViewController:(UIViewController *)vc {
    [SAVideoAd play:placementId fromVC:vc];
}

- (void) setCallback:(sacallback)callback {
    [SAVideoAd setCallback:callback];
}

@end
