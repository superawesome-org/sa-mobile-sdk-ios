//
//  SAVASTModels+Parsing.h
//  Pods
//
//  Created by Gabriel Coman on 18/12/2015.
//
//

#import <Foundation/Foundation.h>
#import "SAVASTModels.h"
#import "TBXML.h"

@interface SAVASTAd (Parsing)

+ (SAVASTAd*) parseXML:(TBXMLElement*)element;

@end

@interface SALinearCreative (Parsing)

+ (SALinearCreative*) parseXML:(TBXMLElement*)element;

@end