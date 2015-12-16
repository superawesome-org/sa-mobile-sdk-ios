//
//  SAWebViewProtocol.h
//  libSAWebView
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/11/2015.
//
//

#import <UIKit/UIKit.h>

//
// @brief: A protocol that defines the three main callbacks for the custom
// SAWebView
@protocol SAWebViewProtocol <NSObject>

// @brief: called when you want to navigate
- (void) saWebViewWillNavigate:(NSURL*)url;

@optional

// @brief: callback to tell when a webview was loaded
- (void) saWebViewDidLoad;

// @brief: callback to tell when a webview wasn't loaded ok
- (void) saWebViewDidFail;

@end
