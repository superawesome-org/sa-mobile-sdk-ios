//
//  SAVideoAdViewController
//  SAMobileSDK
//
//  Created by Balázs Kiss on 03/02/15.
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperAwesome.h"

@interface SAVideoAdViewController : UIViewController <SAVideoAdViewDelegate>

@property (nonatomic,strong) SAVideoAdView *videoView;
@property (assign,nonatomic,getter=isParentalGateEnabled) BOOL parentalGateEnabled;

- (instancetype)initWithAppID:(NSString *)appID placementID:(NSString *)placementID;

@end
