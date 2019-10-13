//
//  SATestUtils.h
//  SANetwork_Tests
//
//  Created by Gabriel Coman on 02/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SATestUtils : NSObject
- (NSData*) fixtureWithName: (NSString*) name ofType: (NSString*) type;
@end
