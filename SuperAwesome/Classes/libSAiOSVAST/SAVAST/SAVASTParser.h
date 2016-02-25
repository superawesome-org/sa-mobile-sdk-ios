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

// weak object delegate to SAVAStParserProtocol
@property (nonatomic, weak) id<SAVASTParserProtocol> delegate;

// parse the VAST URL
- (void) parseVASTURL:(NSString*)url;

@end
