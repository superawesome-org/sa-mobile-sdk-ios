//
//  SAVASTParser.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/14/2015.
//
//

#import <Foundation/Foundation.h>

// vast protocol
#import "SAVASTParserProtocol.h"

@interface SAVASTParser : NSObject

// delegate
@property id<SAVASTParserProtocol> delegate;

// parsing functions
- (void) parseVASTXML:(NSString*)xml;

@end
