//
//  SAViewProtocol.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <Foundation/Foundation.h>

// useful imports
@class SAAd;

@protocol SAViewProtocol <NSObject>

// functions that all SA - Views should implement
- (void) setAd:(SAAd*)ad;
- (SAAd*) getAd;
- (void) play;
- (void) close;
- (void) tryToGoToURL:(NSURL*)url;
- (void) advanceToClick;
- (void) resizeToFrame:(CGRect)frame;

@end