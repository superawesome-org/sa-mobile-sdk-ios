//
//  SAWebView.h
//  libSAWebView
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/11/2015.
//
//

#import <UIKit/UIKit.h>
#import "SAWebViewProtocol.h"

@interface SAWebView : UIWebView <UIWebViewDelegate>

// custom init
- (id) initWithHTML:(NSString*)html andAdSize:(CGSize)size andFrame:(CGRect)frame andDelegate:(id<SAWebViewProtocol>)delegate;

// re-arramge func
- (void) rearrangeForFrame:(CGRect)frame;

@end
