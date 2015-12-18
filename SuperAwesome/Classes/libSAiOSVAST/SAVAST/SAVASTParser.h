//
//  SAVAST2Parser.h
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import <Foundation/Foundation.h>
#import "SAVASTParserProtocol.h"

@interface SAVASTParser : NSObject

@property id<SAVASTParserProtocol> delegate;

- (void) parseVASTURL:(NSString*)url;

@end
