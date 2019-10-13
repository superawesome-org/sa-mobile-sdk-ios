//
//  SATestUtils.m
//  SAAdLoader_Tests
//
//  Created by Gabriel Coman on 04/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SATestUtils.h"

@implementation SATestUtils

- (NSString*) stringFixtureWithName: (NSString*) name ofType: (NSString*) type {
    
    NSString *identifier = @"org.cocoapods.demo.SAAdLoader-Tests";
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
    
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

- (NSData*) dataFixtureWithName: (NSString*) name ofType: (NSString*) type {
    
    NSString *identifier = @"org.cocoapods.demo.SAAdLoader-Tests";
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

