//
//  SAVideoAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAProtocols.h"
#import "SAVASTManagerProtocol.h"


// forward declarations
@class SAParentalGate;
@class SAAd;
@class SAVASTPlayer;
@class SAVASTManager;

@interface SAVideoAd : UIView <SAViewProtocol, SAVASTManagerProtocol> {
    SAAd *ad;
    NSString *destinationURL;
    
    SAParentalGate *gate;
    UIImageView *padlock;
    SAVASTPlayer *player;
    SAVASTManager *manager;
}

@property id<SAAdProtocol> adDelegate;
@property id<SAParentalGateProtocol> parentalGateDelegate;
@property id<SAVideoAdProtocol> videoDelegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

@end
