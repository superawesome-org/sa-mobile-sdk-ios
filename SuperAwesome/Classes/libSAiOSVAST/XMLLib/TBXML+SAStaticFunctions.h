//
//  TBXML+SAStaticFunctions.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/14/2015.
//
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface TBXML (SAStaticFunctions)

// function that returns an array of found elements that correspond to
// the name given for the search, given that the search starts from the current
// element and checks all siblings and children
+ (NSMutableArray*) searchSiblingsAndChildrenOf:(TBXMLElement*)element
                                        forName:(NSString*)name;

// doing the same thing as the function above, only the result is passed down
// as an interation block
+ (void) searchSiblingsAndChildrenOf:(TBXMLElement*)element
                             forName:(NSString*)name
                         andInterate:(TBXMLIterateBlock)block;

// a function that returns a boolean if at least one element given the name
// is found in all siblings and children of the current element
+ (BOOL) checkSiblingsAndChildrenOf:(TBXMLElement*)element
                            forName:(NSString*)name;

@end
