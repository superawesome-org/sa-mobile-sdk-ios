//
//  SABannerAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAProtocol.h"

// class declaration for SABannerAd
@interface SABannerAd : UIView

// "action" methods
- (void) load:(NSInteger)placementId;
- (void) play;
- (BOOL) hasAdAvailable;
- (void) close;
- (void) resize:(CGRect)toframe;

// public "state" setters
- (void) setDelegate:(id<SAProtocol>)delegate;
- (void) setIsParentalGateEnabled:(BOOL)isParentalGateEnabled;

@end
