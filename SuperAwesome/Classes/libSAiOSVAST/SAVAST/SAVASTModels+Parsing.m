//
//  SAVASTModels+Parsing.m
//  Pods
//
//  Created by Gabriel Coman on 18/12/2015.
//
//

#import "SAVASTModels+Parsing.h"
#import "TBXML+SAStaticFunctions.h"
#import "NSString+HTML.h"

@implementation SAVASTAd (Parsing)

+ (SAVASTAd*) parseXML:(TBXMLElement *)adElement {
    // create ad
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
        [ad.Errors addObject:
         [[TBXML textForElement:errElement] stringByDecodingHTMLEntities]];
    }];
    
    // get impressions
    [TBXML searchSiblingsAndChildrenOf:adElement->firstChild forName:@"Impression" andInterate:^(TBXMLElement *impElement) {
        // the impression object is now a more complex one
        SAImpression *impr = [[SAImpression alloc] init];
        impr.isSent = false;
        impr.URL = [[TBXML textForElement:impElement] stringByDecodingHTMLEntities];
        [ad.Impressions addObject:impr];
    }];
    
    // get creatives
    [TBXML searchSiblingsAndChildrenOf:adElement->firstChild forName:@"Creative" andInterate:^(TBXMLElement *creativeElement) {
        SALinearCreative *linear = [SALinearCreative parseXML:creativeElement];
        if (linear) {
            [ad.Creatives addObject:linear];
        }
    }];
    
    return ad;
}


@end

@implementation SALinearCreative (Parsing)

+ (SALinearCreative*) parseXML:(TBXMLElement *)element {
    // first find out what kind of content this creative has
    // is it Linear, NonLinear or CompanionAds?
    BOOL isLinear = [TBXML checkSiblingsAndChildrenOf:element->firstChild forName:@"Linear"];
    
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
            _creative.ClickThrough = [_creative.ClickThrough stringByDecodingHTMLEntities];
            _creative.ClickThrough = [_creative.ClickThrough stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            _creative.ClickThrough = [_creative.ClickThrough stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
            _creative.ClickThrough = [_creative.ClickThrough stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
        }];
        
        // populate click tracking array
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"ClickTracking" andInterate:^(TBXMLElement *ctrackElement) {
            [_creative.ClickTracking addObject:
             [[TBXML textForElement:ctrackElement] stringByDecodingHTMLEntities]];
        }];
        
        // populate custom clicks array
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"CustomClicks" andInterate:^(TBXMLElement *cclickElement) {
            [_creative.CustomClicks addObject:
             [[TBXML textForElement:cclickElement] stringByDecodingHTMLEntities]];
        }];
        
        // populate media files
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"MediaFile" andInterate:^(TBXMLElement *cMediaElement) {
            // since this is a more "complex" object, wich takes data from
            // attributes as well as tag value, split the
            // declaration and array assignment
            SAMediaFile *mediaFile = [[SAMediaFile alloc] init];
            mediaFile.width = [TBXML valueOfAttributeNamed:@"width" forElement:cMediaElement];
            mediaFile.height = [TBXML valueOfAttributeNamed:@"height" forElement:cMediaElement];
            mediaFile.URL = [[TBXML textForElement:cMediaElement] stringByDecodingHTMLEntities];
            [_creative.MediaFiles addObject:mediaFile];
        }];
        
        // populate tracking
        [TBXML searchSiblingsAndChildrenOf:element->firstChild forName:@"Tracking" andInterate:^(TBXMLElement *cTrackingElement) {
            // since this is also a more "complex" object, which takes data from
            // attributes as well as tag value, split the declaration and
            // array assignmenent
            SATracking *tracking = [[SATracking alloc] init];
            tracking.event = [TBXML valueOfAttributeNamed:@"event" forElement:cTrackingElement];
            tracking.URL = [[TBXML textForElement:cTrackingElement] stringByDecodingHTMLEntities];
            [_creative.TrackingEvents addObject:tracking];
        }];
        
        return _creative;
    }
    // non-linear / companion ads is not yet supported
    else {
        return NULL;
    }
}

@end