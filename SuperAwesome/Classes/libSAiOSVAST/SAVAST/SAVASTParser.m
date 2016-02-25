//
//  SAVAST2Parser.m
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import "SAVASTParser.h"

// import XML
#import "TBXML.h"
#import "TBXML+SAStaticFunctions.h"

// import helpes
#import "SAVASTModels+Operations.h"
#import "SAVASTModels+Parsing.h"

// import Utils
#import "SAVASTModels.h"
#import "SAVASTModels+Operations.h"
#import "libSAiOSNetwork.h"
#import "libSAiOSUtils.h"
#import "NSString+HTML.h"

@implementation SAVASTParser

//
// @brief: main Async function
- (void) parseVASTURL:(NSString *)url {
    
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(myQueue, ^{
    
        // get ads array
        NSMutableArray *adsArray = [self parseVAST:url];
        
        // long running stuff
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            for (SAVASTAd *ad in adsArray) {
//                [ad print];
//            }
            
            if (adsArray.count >= 1 ) {
                if (_delegate && [_delegate respondsToSelector:@selector(didParseVASTAndHasAdsResponse:)]) {
                    [_delegate didParseVASTAndHasAdsResponse:adsArray];
                }
            } else {
                if (_delegate && [_delegate respondsToSelector:@selector(didNotFindAnyValidAds)]) {
                    [_delegate didNotFindAnyValidAds];
                }
            }
        });
    });
}

//
// @brief: get ads starting from a root
- (NSMutableArray*) parseVAST:(NSString*)vastURL {
    // create the array of ads that should be returned
    __block NSMutableArray *ads = [[NSMutableArray alloc] init];
    
    // step 1: get the XML
    NSData *xmlData = [SANetwork sendSyncGETToEndpoint:vastURL];
    NSError *xmlError = NULL;
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:xmlData error:&xmlError];
    if (xmlError) {
        return ads;
    }
    
    // step 2. get the correct reference to the root XML element
    __block TBXMLElement *root = tbxml.rootXMLElement;
    
    // step 3. start finding ads and parsing them
    [TBXML searchSiblingsAndChildrenOf:root forName:@"Ad" andInterate:^(TBXMLElement *adElement) {
        
        // check ad type
        BOOL isInLine = [TBXML checkSiblingsAndChildrenOf:adElement->firstChild forName:@"InLine"];
        BOOL isWrapper = [TBXML checkSiblingsAndChildrenOf:adElement->firstChild forName:@"Wrapper"];
        
        // normal InLine case
        if (isInLine) {
            SAVASTAd *inlineAd = [SAVASTAd parseXML:adElement];
            [ads addObject:inlineAd];
        }
        // normal Wrapper case
        else if (isWrapper){
            // get the Wrapper type ad
            SAVASTAd *wrapperAd = [SAVASTAd parseXML:adElement];
            
            // get VAStAdTagURI
            NSString *VASTAdTagURI = @"";
            NSValue *uriPointer = [TBXML findFirstIntanceInSiblingsAndChildrenOf:adElement->firstChild forName:@"VASTAdTagURI"];
            if (uriPointer) {
                TBXMLElement *uriElement = [uriPointer pointerValue];
                VASTAdTagURI = [[TBXML textForElement:uriElement] stringByDecodingHTMLEntities];
            }
            
            // call back this function recursevly
            NSMutableArray *foundAds = [self parseVAST:VASTAdTagURI];
            
            // now try to joing creatives - that's a bit tricky
            // step 1: remove all creatives other than one from the Wrapper
            [wrapperAd.Creatives removeAllButFirstElement];
            // step 2: now go through the resulting ads, remove all but one
            // element from the creatives, and sum them
            for (SAVASTAd *foundAd in foundAds) {
                // [foundAd.Creatives removeAllButFirstElement];
                [foundAd sumAd:wrapperAd];
            }
            
            // add the object of the array to the main array
            [ads addObjectsFromArray:foundAds];
        }
    }];
    
    return ads;
}


@end
