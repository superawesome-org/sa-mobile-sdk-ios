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

@interface SAVideoAd : UIView <SAViewProtocol>

@property (nonatomic, weak) id<SAAdProtocol> adDelegate;
@property (nonatomic, weak) id<SAParentalGateProtocol> parentalGateDelegate;
@property (nonatomic, weak) id<SAVideoAdProtocol> videoDelegate;
@property (nonatomic, assign) BOOL isParentalGateEnabled;

@end
