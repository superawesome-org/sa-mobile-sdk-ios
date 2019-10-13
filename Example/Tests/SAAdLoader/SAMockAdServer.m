//
//  SAMockAdServer.m
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAMockAdServer.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "SAResponseFactory.h"

@interface SAMockAdServer ()
@property (nonatomic, strong) SAResponseFactory *factory;
@end

@implementation SAMockAdServer

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
        
        
        if ([url containsString: @"/ad/1000"])
            return [self->_factory adResponse:@"mock_ad_cpm_banner_response"];
        else if ([url containsString:@"/ad/1001"])
            return [self->_factory adResponse:@"mock_ad_cpi_banner_response"];
        else if ([url containsString:@"/ad/1002"])
            return [self->_factory adResponse:@"mock_ad_cpm_video_response"];
        else if ([url containsString:@"/vast/vast.xml"])
            return [self->_factory vastResponse:@"mock_vast_response"];
        else if ([url containsString:@"/resource/videoresource.mp4"])
            return [self->_factory fileResponse:@"videoresource"];
        else if ([url containsString:@"/ad/1003"])
            return [self->_factory emptyResponse];
        else if ([url containsString:@"/ad/1004"])
            return [self->_factory malformedResponse];
        else if ([url containsString:@"/ad/1005"])
            return [self->_factory adResponse:@"mock_ad_cpm_video_bad_response"];
        else if ([url containsString:@"/ad/1006"])
            return [self->_factory adResponse:@"mock_ad_cpm_video_unreachable_video_resource"];
        else if ([url containsString:@"/vast/vast_unreachable_video"])
            return [self->_factory adResponse:@"mock_vast_unreachable_video_response"];
        else
            return [self->_factory sendError];
    }];
}

- (void) shutdown {
    [OHHTTPStubs removeAllStubs];
}

@end
