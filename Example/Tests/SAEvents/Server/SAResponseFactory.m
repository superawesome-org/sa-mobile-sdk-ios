//
//  SAResponseFactory.m
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAResponseFactory.h"

@implementation SAResponseFactory

- (OHHTTPStubsResponse*) successResponse {
    NSData *data = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"Content-Type": @"application/xml"};
    return [OHHTTPStubsResponse responseWithData:data statusCode:200 headers:headers];
}

- (OHHTTPStubsResponse*) timeoutResponse {
    NSError* notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
    return [OHHTTPStubsResponse responseWithError:notConnectedError];
}

@end
