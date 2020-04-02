//
//  SAResponseFactory.h
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OHHTTPStubs;

@interface SAResponseFactory : NSObject
- (HTTPStubsResponse*) adResponse:(NSString*) json;
- (HTTPStubsResponse*) vastResponse: (NSString*) xml;
- (HTTPStubsResponse*) malformedResponse;
- (HTTPStubsResponse*) emptyResponse;
- (HTTPStubsResponse*) fileResponse: (NSString*) file;

- (HTTPStubsResponse*) successResponse;
- (HTTPStubsResponse*) timeoutResponse;

- (HTTPStubsResponse*) sendResponse: (NSString*) xml;

- (HTTPStubsResponse*) sendError;

@end
