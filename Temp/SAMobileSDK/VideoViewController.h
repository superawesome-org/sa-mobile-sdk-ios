//
//  VideoViewController.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 26/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperAwesome.h"

@interface VideoViewController : UIViewController <SAVideoAdViewDelegate>

@property (nonatomic,strong) IBOutlet SAVideoAdView *videoView;

- (IBAction)startVideoAd:(id)sender;
- (IBAction)stopVideoAd:(id)sender;

@end
