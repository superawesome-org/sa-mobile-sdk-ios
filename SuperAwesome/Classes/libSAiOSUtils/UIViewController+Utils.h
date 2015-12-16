//
//  UIViewController+Utils.h
//  libSAiOSUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 07/10/2015.
//
//

#import <UIKit/UIKit.h>

//
// @brief: Category over UIViewController that makes it easy to get the
// current VC shown
@interface UIViewController (Utils)

+ (UIViewController*) currentViewController;

@end
