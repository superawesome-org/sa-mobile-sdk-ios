//
//  SATestUtils.h
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SATestUtils : NSObject
- (NSString*) stringFixtureWithName: (NSString*) name ofType: (NSString*) type;
- (NSData*) dataFixtureWithName: (NSString*) name ofType: (NSString*) type;
@end
