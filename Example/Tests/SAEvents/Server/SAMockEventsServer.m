//
//  SAMockAdServer.m
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAMockEventsServer.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "SAResponseFactory.h"

@interface SAMockEventsServer ()
@property (nonatomic, strong) SAResponseFactory *factory;
@end

@implementation SAMockEventsServer

- (id) init {
    if (self = [super init]) {
        _factory = [[SAResponseFactory alloc] init];
    }
    return self;
}

- (void) start {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *url = [request URL].absoluteString;
        
        /*
         * Click event
         */
        if ([url containsString: @"/click"]) {
            if ([url containsString:@"placement=1000"]) {
                return [self->_factory successResponse];
            } else {
                return [self->_factory timeoutResponse];
            }
        }
        /*
         * Video click event
         */
        else if ([url containsString:@"/video/click"]) {
            if ([url containsString:@"placement=1000"]) {
                return [self->_factory successResponse];
            } else {
                return [self->_factory timeoutResponse];
            }
        }
        /*
         * Impression event
         */
        else if ([url containsString:@"/impression"]) {
            if ([url containsString:@"placement=1000"]) {
                return [self->_factory successResponse];
            } else {
                return [self->_factory timeoutResponse];
            }
        }
        /*
         * Any type of URL event
         */
        else if ([url containsString:@"/api/url"]) {
            if ([url containsString:@"placement=1000"]) {
                return [self->_factory successResponse];
            } else {
                return [self->_factory timeoutResponse];
            }
        }
        /*
         * Series of VAST events
         */
        else if ([url containsString:@"/vast/event/vast_impression?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_click_through?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_creativeView?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_start?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_firstQuartile?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_midpoint?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_thirdQuartile?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_complete?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_click_tracking?placement=1000"])
            return [self->_factory successResponse];
        else if ([url containsString:@"/vast/event/vast_error?placement=1000"])
            return [self->_factory successResponse];
        /*
         * Viewable impression event
         */
        else if ([url containsString:@"/event"]) {
            if ([url containsString:@"placement%22%3A1000"]) {
                return [self->_factory successResponse];
            } else {
                return [self->_factory timeoutResponse];
            }
        }
        else {
            return [self->_factory timeoutResponse];
        }
    }];
}

- (void) shutdown {
    [OHHTTPStubs removeAllStubs];
}

@end
