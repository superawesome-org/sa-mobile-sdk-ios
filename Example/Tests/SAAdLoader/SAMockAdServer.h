//
//  SAMockAdServer.h
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OHHTTPStubs;

@interface SAMockAdServer : NSObject
- (void) start;
- (void) shutdown;
@end
