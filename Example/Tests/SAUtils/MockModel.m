//
//  TestClass.m
//  SAUtils
//
//  Created by Gabriel Coman on 02/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//
#import "MockModel.h"

@implementation MockModel

- (id) initWithName:(NSString *)name andIsOK:(BOOL)isOK andPay:(NSInteger)pay{
    if (self = [super init]) {
        _name = name;
        _isOK = isOK;
        _pay = pay;
    }
    return self;
}

- (void) method1 {
    NSLog(@"Method 1");
}

- (NSString*) method2 {
    NSLog(@"Method 2");
    return @"Return value";
}

+ (NSInteger) method3 {
    NSLog(@"Method 3");
    return 33;
}

+ (void) method4:(NSString*) param {
    NSLog(@"Method 4 with %@", param);
}

+ (void) method5:(CGRect) rect {
    NSLog(@"Method 5 with %@", NSStringFromCGRect(rect));
}

@end
