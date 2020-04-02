//
//  SANetwork_Network_Tests.m
//  SANetwork
//
//  Created by Gabriel Coman on 20/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SANetwork.h"
@import OHHTTPStubs;

@interface SANetwork_Network_Tests : XCTestCase
@property (nonatomic, strong) SANetwork *network;
@end

@implementation SANetwork_Network_Tests

- (void) setUp {
    [super setUp];
    _network = [[SANetwork alloc] initWithTimeout:1];
}

- (void) tearDown {
    [HTTPStubs removeAllStubs];
    [super tearDown];
}

- (void) test_SANetwork_SendGET_WithSuccess {
    
    NSString *url = @"https://my.mock.api/endpoint";
    NSDictionary *query = @{};
    NSDictionary *header = @{};
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = @"{}";
        NSData* data = [fixture dataUsingEncoding:NSUTF8StringEncoding];
        return [HTTPStubsResponse responseWithData:data
                                          statusCode:200
                                             headers:@{@"Content-Type":@"application/json"}];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertEqual(status, 200);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"{}", payload);
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGET_WithSuccessWhenQueryAndHeaderAreNull {
    
    NSString *url = @"https://my.mock.api/endpoint";
    NSDictionary *query = nil;
    NSDictionary *header = (NSDictionary*)[NSNull null];
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = @"{}";
        NSData* data = [fixture dataUsingEncoding:NSUTF8StringEncoding];
        return [HTTPStubsResponse responseWithData:data
                                          statusCode:200
                                             headers:@{@"Content-Type":@"application/json"}];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertEqual(status, 200);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"{}", payload);
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGET_WithTimeout {
    
    NSString *url = @"https://my.mock.api/endpoint";
    NSDictionary *query = @{};
    NSDictionary *header = @{};
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = @"{}";
        NSData* data = [fixture dataUsingEncoding:NSUTF8StringEncoding];
        return [[HTTPStubsResponse responseWithData:data
                                          statusCode:200
                                             headers:@{@"Content-Type":@"application/json"}] requestTime:1.0 responseTime:2.0];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertEqual(status, 0);
        XCTAssertNil(payload);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGET_WithNoNetwork {
    
    NSString *url = @"https://my.mock.api/endpoint";
    NSDictionary *query = @{};
    NSDictionary *header = @{};
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSError* notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        return [HTTPStubsResponse responseWithError:notConnectedError];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertEqual(status, 0);
        XCTAssertNil(payload);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGet_WithErrorBeauseURLIsNil {
    
    NSString *url = nil;
    NSDictionary *query = nil;
    NSDictionary *header = (NSDictionary*)[NSNull null];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertNil(payload);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGET_WithErrorBecauseURLIsEmpty {
    
    NSString *url = @"";
    NSDictionary *query = nil;
    NSDictionary *header = (NSDictionary*)[NSNull null];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertNil(payload);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGET_WithErrorBecauseURLIsMalformed {
    
    NSString *url = @"jkklsj///_txt.s.a";
    NSDictionary *query = @{};
    NSDictionary *header = (NSDictionary*)[NSNull null];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertNil(payload);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendGET_WithErrorBecauseURLIsANullClass {
    
    NSString *url = (NSString*)[NSNull null];
    NSDictionary *query = @{};
    NSDictionary *header = (NSDictionary*)[NSNull null];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendGET:url withQuery:query andHeader:header withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        
        XCTAssertNil(payload);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SANetwork_SendPOST_WithSuccess {
    
    NSString *url = @"https://my.mock.api/endpoint";
    NSDictionary *query = @{};
    NSDictionary *header = @{};
    NSDictionary *body = @{@"value":@(true)};
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = @"{}";
        NSData* data = [fixture dataUsingEncoding:NSUTF8StringEncoding];
        return [HTTPStubsResponse responseWithData:data
                                        statusCode:200
                                           headers:@{@"Content-Type":@"application/json"}];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    [_network sendPOST:url withQuery:query andHeader:header andBody:body withResponse:^(NSInteger status, NSString *payload, BOOL success) {
        XCTAssertEqual(status, 200);
        XCTAssertNotNil(payload);
        XCTAssertEqualObjects(@"{}", payload);
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

@end
