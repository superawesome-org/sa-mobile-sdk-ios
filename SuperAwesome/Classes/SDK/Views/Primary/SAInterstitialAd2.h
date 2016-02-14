//
//  SAInterstitialAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAViewProtocol.h"
#import "SAAdProtocol.h"
#import "SAParentalGateProtocol.h"

@class SAAd;
@class SABannerAd2;

@interface SAInterstitialAd2 : UIViewController <SAViewProtocol> {
    SAAd *ad;
    CGRect adviewFrame;
    CGRect buttonFrame;
    
    SABannerAd2 *banner;
    UIButton *closeBtn;
}

@property id<SAAdProtocol> adDelegate;
@property id<SAParentalGateProtocol> parentalGateDelegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

@end
