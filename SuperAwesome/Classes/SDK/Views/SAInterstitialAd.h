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

@interface SAInterstitialAd : UIViewController <SAViewProtocol> {
    SAAd *ad;
    CGRect adviewFrame;
    CGRect buttonFrame;
    
    SABannerAd *banner;
    UIButton *closeBtn;
}

@property id<SAAdProtocol> adDelegate;
@property id<SAParentalGateProtocol> parentalGateDelegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

@end
