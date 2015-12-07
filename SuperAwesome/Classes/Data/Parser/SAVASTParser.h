//
//  SAVASTParser.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/10/2015.
//
//

#import <Foundation/Foundation.h>

// callback for a success method with AD response
typedef void (^parseResult)(NSString *clickURL);

//
// @brief: This is a wrapper around NSXMLParser
// It's goal is to parse a standard VAST Tag and find the ClickThrough tag's
// value, which is the correct clickURL in case of video ads
@interface SAVASTParser : NSObject

// static function that performs the VAST Tag parsing
- (void) findCorrectVASTClickFor:(NSString*)vastURL withResult:(parseResult)result;

@end
