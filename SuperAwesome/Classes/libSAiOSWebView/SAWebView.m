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

// ad view internal stuff
@property (nonatomic, weak) id<SAWebViewProtocol> sadelegate;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, assign) CGSize size;

// load once
@property (nonatomic, assign) BOOL loadedOnce;

@end

@implementation SAWebView

- (id) initWithHTML:(NSString *)html andAdSize:(CGSize)size andFrame:(CGRect)frame andDelegate:(id<SAWebViewProtocol>)delegate {
    if (self = [super initWithFrame:frame]) {
        // copy important vals
        _sadelegate = delegate;
        _html = html;
        _size = size;
        
        // customize stuff
        self.delegate = self;
        self.scalesPageToFit = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.bounces = NO;
        self.allowsInlineMediaPlayback = NO;
        self.mediaPlaybackRequiresUserAction = YES;
        
        // set scale
        CGFloat xscale = frame.size.width / _size.width;
        CGFloat yscale = frame.size.height / _size.height;
        CGFloat scale = MIN(xscale, yscale);
        
        // modify HTML
        _html = html;
        _html = [_html stringByReplacingOccurrencesOfString:@"_WIDTH_" withString:[NSString stringWithFormat:@"%ld", (long)_size.width]];
        _html = [_html stringByReplacingOccurrencesOfString:@"_HEIGHT_" withString:[NSString stringWithFormat:@"%ld", (long)_size.height]];
        _html = [_html stringByReplacingOccurrencesOfString:@"_PARAM_SCALE_" withString:[NSString stringWithFormat:@"%.2f", scale]];
        
        // reload the webview
        [self loadHTMLString:_html baseURL:NULL];
    }
    
    return self;
}

- (void) rearrangeForFrame:(CGRect)frame {
    
    // set frame
    self.frame = frame;
    
    // set scale
    CGFloat xscale = frame.size.width / _size.width;
    CGFloat yscale = frame.size.height / _size.height;
    CGFloat scale = MIN(xscale, yscale);
    
    NSMutableString *script = [[NSMutableString alloc] init];
    [script appendString:@"viewport = document.querySelector('meta[name=viewport]');"];
    [script appendFormat:@"viewport.setAttribute('content', 'width=device-width, initial-scale=%.2f, maximum-scale=%.2f, user-scalable=no, target-densitydpi=device-dpi');", scale, scale];
    
    [self stringByEvaluatingJavaScriptFromString:script];
}

#pragma mark <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL shouldContinue = true;
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        shouldContinue = false;
    } else {
        if ([request.URL.absoluteString rangeOfString:@"&redir=" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            shouldContinue = false;
        }
        if ([request.URL.relativeString rangeOfString:@"/v2/click"].location != NSNotFound) {
            shouldContinue = false;
        }
    }
    
    if (!shouldContinue) {
    
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
    
    // call delegate
    if (_sadelegate != NULL && [_sadelegate respondsToSelector:@selector(saWebViewDidLoad)] && !_loadedOnce) {
        [_sadelegate saWebViewDidLoad];
        _loadedOnce = true;
    }
}

- (void) webView:(UIWebView*) webView didFailLoadWithError:(NSError *)error {
    if (_sadelegate != NULL && [_sadelegate respondsToSelector:@selector(saWebViewDidFail)]) {
        [_sadelegate saWebViewDidFail];
    }
}

#pragma mark <UIScrollViewDelegate>

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

@end
