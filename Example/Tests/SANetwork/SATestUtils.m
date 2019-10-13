//
//  SATestUtils.m
//  SANetwork_Tests
//
//  Created by Gabriel Coman on 02/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SATestUtils.h"

@implementation SATestUtils

- (NSData*) fixtureWithName: (NSString*) name ofType: (NSString*) type {
    
    NSString *identifier = @"org.cocoapods.demo.SANetwork-Tests";
    NSBundle *bundle = [NSBundle bundleWithIdentifier:identifier];
    
    if (bundle == nil) {
        NSLog(@"Bundle is nil");
        return nil;
    }
    
    NSString *bundlePath = [bundle pathForResource:@"fixtures" ofType:@"bundle"];
    
    if (bundlePath == nil) {
        NSLog(@"Bundle Path is nil");
        return nil;
    }
    
    NSBundle *fixturesBundle = [NSBundle bundleWithPath:bundlePath];
    
    if (fixturesBundle == nil) {
        NSLog(@"Fixtures Bundle is nil");
        return nil;
    }
    
    NSString *filePath = [fixturesBundle pathForResource:name ofType:type];
    
    if (filePath == nil) {
        NSLog(@"File Path is nil");
        return nil;
    }
    
    return [NSData dataWithContentsOfFile:filePath];
}

@end
