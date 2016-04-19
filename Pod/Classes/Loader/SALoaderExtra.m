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

// import safile downloader
#import "SAFileDownloader.h"

// modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"

@interface SALoaderExtra () <SAVASTParserProtocol>
// custom internal variables
@property (nonatomic, strong) SAVASTParser *parser;
@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) extraDone done;
@end

@implementation SALoaderExtra

- (void) getExtraData:(SAAd*)ad andDone:(extraDone)done {
    // get function reference to Done
    _ad = ad;
    _done = done;
    
    // get type
    SACreativeFormat type = _ad.creative.format;

    // init ad data
    _ad.creative.details.data = [[SAData alloc] init];
    
    switch (type) {
        // first big case
        case video: {
            // start async parse
            _parser = [[SAVASTParser alloc] init];
            _parser.delegate = self;
            [_parser parseVASTURL:_ad.creative.details.vast];
            break;
        }
        // second big case
        case image:
        case rich:
        case tag: {
            _ad.creative.details.data.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:_ad];
            _done(_ad);
            break;
        }
        case invalid:{
            _done(_ad);
            break;
        }
    }
}

- (void) didParseVAST:(NSArray*)ads {
    _ad.creative.details.data.vastAds = ads;
    _done(_ad);
}

@end
