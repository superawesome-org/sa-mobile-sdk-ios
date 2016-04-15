//
//  SALoaderExtra.m
//  Pods
//
//  Created by Gabriel Coman on 15/04/2016.
//
//

// header import
#import "SALoaderExtra.h"

// parsers
#import "SAVASTParser.h"
#import "SAHTMLParser.h"

// modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"

@interface SALoaderExtra ()
// custom internal variables
@property (nonatomic, strong) SAVASTParser *parser;
@property (nonatomic, strong) SAAd *ad;
@end

@implementation SALoaderExtra

- (id) initWithAd:(SAAd *)ad {
    if (self = [super init]) {
        _ad = ad;
    }
    
    return self;
}

- (void) getExtraData:(extraDone)done {
    SACreativeFormat type = _ad.creative.format;
    
    // init ad data
    _ad.creative.details.data = [[SAData alloc] init];
    
    switch (type) {
        // first big case
        case video: {
            //
            done(_ad);
            break;
        }
        // second big case
        case image:
        case rich:
        case tag: {
            _ad.creative.details.data.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:_ad];
            done(_ad);
            break;
        }
        case invalid:{
            done(_ad);
            break;
        }
    }
}

@end
