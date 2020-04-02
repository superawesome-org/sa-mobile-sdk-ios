//
//  SAResponseFactory.m
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAResponseFactory.h"
#import "SATestUtils.h"

@interface SAResponseFactory ()
@property (nonatomic, strong) SATestUtils *utils;
@end

@implementation SAResponseFactory

- (id) init {
    if (self = [super init]) {
        _utils = [[SATestUtils alloc] init];
    }
    
    return self;
}

- (NSString*) sendJSONString: (NSString*) json {
    return [_utils stringFixtureWithName:json ofType:@"json"];
}

- (NSString*) sendVASTTag: (NSString*) xml {
    return [_utils stringFixtureWithName:xml ofType:@"xml"];
}

- (HTTPStubsResponse*) adResponse:(NSString*) json {
    NSString *ad = [self sendJSONString:json];
    NSData *data = [ad dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"Content-Type": @"application/xml"};
    return [HTTPStubsResponse responseWithData:data statusCode:200 headers:headers];
}

- (HTTPStubsResponse*) vastResponse: (NSString*) xml {
    NSString *xmlString = [self sendVASTTag:xml];
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"Content-Type": @"application/xml"};
    return [HTTPStubsResponse responseWithData:data statusCode:200 headers:headers];
}

- (HTTPStubsResponse*) malformedResponse {
    return [self adResponse:@"mock_ad_malformed_response"];
}

- (HTTPStubsResponse*) emptyResponse {
    return [self adResponse:@"mock_ad_empty_response"];
}

- (HTTPStubsResponse*) fileResponse: (NSString*) file {
    NSData* data = [_utils dataFixtureWithName:file ofType:@"mp4"];
    NSDictionary *headers = @{@"Content-Type": @"application/xml"};
    return [HTTPStubsResponse responseWithData:data statusCode:200 headers:headers];
}

- (HTTPStubsResponse*) sendError {
    NSError* notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
    return [HTTPStubsResponse responseWithError:notConnectedError];
}

- (HTTPStubsResponse*) successResponse {
    NSData *data = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"Content-Type": @"application/xml"};
    return [HTTPStubsResponse responseWithData:data statusCode:200 headers:headers];
}

- (HTTPStubsResponse*) timeoutResponse {
    NSError* notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
    return [HTTPStubsResponse responseWithError:notConnectedError];
}

- (HTTPStubsResponse*) sendResponse: (NSString*) xml {
    NSString *xmlString = [self sendVASTTag:xml];
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"Content-Type": @"application/xml"};
    return [HTTPStubsResponse responseWithData:data statusCode:200 headers:headers];
}

@end
