//
//  SAInterstitialAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAProtocols.h"

@class SAAd;
@class SABannerAd;

@interface SAInterstitialAd : UIViewController <SAViewProtocol>

@property (nonatomic, weak) id<SAProtocol> delegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldLockOrientation;
@property (nonatomic, assign) NSUInteger lockOrientation;

@end
