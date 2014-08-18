//
//  SAInterstitialView.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 12/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADTECHMobileSDK/ADTECHMobileSDK.h>

@class SAInterstitialView;

@protocol SAInterstitialViewDelegate <NSObject>
@optional
- (void)didHideInterstitialView:(SAInterstitialView *)interstitialView;
@end


@interface SAInterstitialView : NSObject <ATInterstitialViewDelegate>

@property (nonatomic,weak) id<SAInterstitialViewDelegate> delegate;

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)present;

@end
