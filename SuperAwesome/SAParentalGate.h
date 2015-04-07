//
//  ParentalGate.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 16/09/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SAParentalGate;

@protocol SAParentalGateDelegate <NSObject>
@optional

- (void)didCancelParentalGate:(SAParentalGate *)parentalGate;
- (void)didFailChallengeForParentalGate:(SAParentalGate *)parentalGate;
- (void)didGetThroughParentalGate:(SAParentalGate *)parentalGate;

@end

@interface SAParentalGate : UIView <UIAlertViewDelegate>

@property (nonatomic,weak) id<SAParentalGateDelegate> delegate;

- (void)show;

@end
