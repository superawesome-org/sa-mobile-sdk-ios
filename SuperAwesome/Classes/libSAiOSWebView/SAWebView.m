//
//  SAWebView.h
//  libSAWebView
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/11/2015.
//
//

#import "SAWebView.h"

@interface SAWebView () <UIScrollViewDelegate>

// delegate
@property id<SAWebViewProtocol> sadelegate;

@end

@implementation SAWebView

- (id) initWithFrame:(CGRect)frame andHTML:(NSString *)html andDelegate:(id<SAWebViewProtocol>)delegate {
    if (self = [super initWithFrame:frame]) {
        
        // proper customization
        self.delegate = self;
        self.scalesPageToFit = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.bounces = NO;
        
        // delegate
        self.sadelegate = delegate;
        
        // start loading HTML
        [self loadHTMLString:html baseURL:NULL];
    }
    
    return self;
}

#pragma mark <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    
        // send a click message
        NSURL *url = [request URL];
        if (_sadelegate != NULL && [_sadelegate respondsToSelector:@selector(saWebViewWillNavigate:)]) {
            [_sadelegate saWebViewWillNavigate:url];
        }
        
        return false;
    }
    
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // do nothing
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_sadelegate != NULL && [_sadelegate respondsToSelector:@selector(saWebViewDidLoad)]) {
        [_sadelegate saWebViewDidLoad];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (_sadelegate != NULL && [_sadelegate respondsToSelector:@selector(saWebViewDidFail)]) {
        [_sadelegate saWebViewDidFail];
    }
}

#pragma mark <UIScrollViewDelegate>

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

@end
