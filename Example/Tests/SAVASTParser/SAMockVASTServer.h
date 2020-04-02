//
//  SAMockVASTServer.h
//  SAVASTParser_Example
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OHHTTPStubs;

@interface SAMockVASTServer : NSObject
- (void) start;
- (void) shutdown;
@end
