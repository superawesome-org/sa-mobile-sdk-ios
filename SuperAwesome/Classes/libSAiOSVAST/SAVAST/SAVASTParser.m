//
//  SAVASTParser.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/14/2015.
//
//

// import headers
#import "SAVASTParser.h"

// import modelspace
#import "SAVASTModels.h"

// parser
#import "TBXML.h"
#import "TBXML+SAStaticFunctions.h"

@interface SAVASTParser ()

// the current vast
@property (nonatomic, strong) SAVAST *_cvast;

@end

@implementation SAVASTParser

////////////////////////////////////////////////////////////////////////////////
// Main Public Parse functions
////////////////////////////////////////////////////////////////////////////////

- (void) parseVASTXML:(NSString *)xml {
    // init the parser
    NSError *xmlError = NULL;
    TBXML *tbxml = [[TBXML alloc] initWithXMLString:xml error:&xmlError];
    
    // check for error
    if (!xmlError) {
        // start parsing
        if (tbxml.rootXMLElement) {
            [self parseAdsInVAST:tbxml.rootXMLElement];
            [__cvast printShortVersion];
            [self validateAndReturnData];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(didFindInvalidVASTResponse)]) {
            [_delegate didFindInvalidVASTResponse];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// Private hidden functions that do the heavy lifting
////////////////////////////////////////////////////////////////////////////////

- (void) parseAdsInVAST:(TBXMLElement*) element {
    __cvast = [[SAVAST alloc] init];
    __cvast.Ads = [[NSMutableArray alloc] init];
    
    // get all ads
    [TBXML searchSiblingsAndChildrenOf:element forName:@"Ad" andInterate:^(TBXMLElement *adElement) {
        // form the ad
        SAVASTAd *ad = [[SAVASTAd alloc] init];
        
        // get attributes
        ad._id = [TBXML valueOfAttributeNamed:@"id" forElement:adElement];
        ad.sequence = [TBXML valueOfAttributeNamed:@"sequence" forElement:adElement];
        ad.type = Invalid;
        
        // init arrays of data
        ad.Errors = [[NSMutableArray alloc] init];
        ad.Impressions = [[NSMutableArray alloc] init];
        ad.Creatives = [[NSMutableArray alloc] init];
        
        // check ad type
        BOOL isInLine = [TBXML checkSiblingsAndChildrenOf:adElement->firstChild forName:@"InLine"];
        BOOL isWrapper = [TBXML checkSiblingsAndChildrenOf:adElement->firstChild forName:@"Wrapper"];
        
        if (isInLine) ad.type = InLine;
        if (isWrapper) ad.type = Wrapper;
        
        // get errors
        [TBXML searchSiblingsAndChildrenOf:adElement->firstChild forName:@"Error" andInterate:^(TBXMLElement *errElement) {
            [ad.Errors addObject:[TBXML textForElement:errElement]];
        }];
        
        // get impressions
        [TBXML searchSiblingsAndChildrenOf:adElement->firstChild forName:@"Impression" andInterate:^(TBXMLElement *impElement) {
            // the impression object is now a more complex one
            SAImpression *impr = [[SAImpression alloc] init];
            impr.isSent = false;
            impr.URL = [TBXML textForElement:impElement];
            [ad.Impressions addObject:impr];
        }];
        
        // get creatives
        [TBXML searchSiblingsAndChildrenOf:adElement->firstChild forName:@"Creative" andInterate:^(TBXMLElement *creativeElement) {
            [ad.Creatives addObject:[self parseCreativeInAd:creativeElement]];
        }];
        
        // return the ad
        [__cvast.Ads addObject:ad];
    }];
}

- (SAVASTCreative*) parseCreativeInAd:(TBXMLElement*)element{
    
    // first find out what kind of content this creative has
    // is it Linear, NonLinear or CompanionAds?
    BOOL isLinear = [TBXML checkSiblingsAndChildrenOf:element->firstChild forName:@"Linear"];
    BOOL isNonLinear = [TBXML checkSiblingsAndChildrenOf:element->firstChild forName:@"NonLinear"];
    BOOL isCompaionAds = [TBXML checkSiblingsAndChildrenOf:element->firstChild forName:@"CompanionAds"];
    
    // init as a linear Creative
    if (isLinear) {
        // create linear creative
        SALinearCreative *_creative = [[SALinearCreative alloc] init];
        
        // get attributes
        _creative.type = Linear;
        _creative._id = [TBXML valueOfAttributeNamed:@"id" forElement:element];
        _creative.sequence = [TBXML valueOfAttributeNamed:@"sequence" forElement:element];
        
        // create arrays
        _creative.ClickTracking = [[NSMutableArray alloc] init];
        _creative.CustomClicks = [[NSMutableArray alloc] init];
        _creative.MediaFiles = [[NSMutableArray alloc] init];
        _creative.TrackingEvents = [[NSMutableArray alloc] init];
        
        // populate duration
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"Duration" andInterate:^(TBXMLElement *durElement) {
            _creative.Duration = [TBXML textForElement:durElement];
        }];
        
        // populate clickthrough
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"ClickThrough" andInterate:^(TBXMLElement *clickElement) {
            _creative.ClickThrough = [TBXML textForElement:clickElement];
        }];
        
        // populate click tracking array
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"ClickTracking" andInterate:^(TBXMLElement *ctrackElement) {
            [_creative.ClickTracking addObject:[TBXML textForElement:ctrackElement]];
        }];
        
        // populate custom clicks array
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"CustomClicks" andInterate:^(TBXMLElement *cclickElement) {
            [_creative.CustomClicks addObject:[TBXML textForElement:cclickElement]];
        }];
        
        // populate media files
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"MediaFile" andInterate:^(TBXMLElement *cMediaElement) {
            // since this is a more "complex" object, wich takes data from
            // attributes as well as tag value, split the
            // declaration and array assignment
            SAMediaFile *mediaFile = [[SAMediaFile alloc] init];
            mediaFile.width = [TBXML valueOfAttributeNamed:@"width" forElement:cMediaElement];
            mediaFile.height = [TBXML valueOfAttributeNamed:@"height" forElement:cMediaElement];
            mediaFile.URL = [TBXML textForElement:cMediaElement];
            [_creative.MediaFiles addObject:mediaFile];
        }];
        
        // populate tracking
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"Tracking" andInterate:^(TBXMLElement *cTrackingElement) {
            // since this is also a more "complex" object, which takes data from
            // attributes as well as tag value, split the declaration and
            // array assignmenent
            SATracking *tracking = [[SATracking alloc] init];
            tracking.event = [TBXML valueOfAttributeNamed:@"event" forElement:cTrackingElement];
            tracking.URL = [TBXML textForElement:cTrackingElement];
            [_creative.TrackingEvents addObject:tracking];
        }];
        
        return _creative;
    }
    // non-linear is not yet supported
    else if (isNonLinear) {
        SANonLinearCreative *nonlinear = [[SANonLinearCreative alloc] init];
        nonlinear.type = NonLinear;
        return nonlinear;
    }
    // companion ads not yet supported
    else if (isCompaionAds) {
        SACompanionAdsCreative *companions = [[SACompanionAdsCreative alloc] init];
        companions.type = CompanionAds;
        return companions;
    }
    // no good case found
    else {
        return [[SAVASTCreative alloc] init];
    }
}

////////////////////////////////////////////////////////////////////////////////
// Validating, getting rid of unused data and trying to return something
////////////////////////////////////////////////////////////////////////////////

//
// @brief: basically this function's main purpose is to validate the data
// (since the TBXML parser seems to be going on the idea that <every> XML is valid)
// and then return <just> the data that can be actually rendered at the moment
//
// @brief2: The data that <can> be rendered at the moment should be:
//  - any InLine type Ad (must be at least one)
//      - any Linear type Creative (must be at least one)
//
// @warn: If the conditions above are not met, the VAST response is not considered
// valid and an error callback should be sent

- (void) validateAndReturnData {
    
    // init return array
    NSMutableArray *returnAdsArray = [[NSMutableArray alloc] init];
    
    for (SAVASTAd *ad in __cvast.Ads) {
        if (ad.type == InLine) {
            NSMutableArray *creativesToDelete = [[NSMutableArray alloc] init];
            
            // gather in-valid creative types
            for (SAVASTCreative *c in ad.Creatives) {
                if (c.type != Linear) {
                    [creativesToDelete addObject:c];
                }
            }
            
            // delete them
            [ad.Creatives removeObjectsInArray:creativesToDelete];
            
            // add to return ads - only if there is at least one creative
            if (ad.Creatives.count > 0) {
                [returnAdsArray addObject:ad];
            }
        }
    }
    
    // return success only if there is at least one InLine ad With at least
    // one Linear creative
    if (returnAdsArray.count > 0) {
        // print final result
        for (SAVASTAd *ad in returnAdsArray) {
            [ad print];
        }
        
        // send this forward
        if (_delegate && [_delegate respondsToSelector:@selector(didParseVASTAndHasAdsResponse:)]) {
            [_delegate didParseVASTAndHasAdsResponse:returnAdsArray];
        }
    }
    // otherwise error
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(didNotFindAnyValidAds)]) {
            [_delegate didNotFindAnyValidAds];
        }
    }
    
    
}

@end
