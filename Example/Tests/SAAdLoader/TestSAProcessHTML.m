//
//  SASAAdLoader_ProcessHTML_Tests.m
//  SAAdLoader
//
//  Created by Gabriel Coman on 18/01/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SAProcessHTML.h"

@interface TestSAProcessHTML : XCTestCase
@end

@implementation TestSAProcessHTML

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAProcessHTML_FormatCreativeIntoImageHTML_WithClick {

    SAAd *ad = [[SAAd alloc] init];
    ad.creative.format = SA_Image;
    ad.creative.details.image = @"https://ads.superawesome.tv/v2/demo_images/320x50.jpg";
    ad.creative.clickUrl = @"http://hotnews.ro";
    ad.creative.details.media.html = [SAProcessHTML formatCreativeIntoImageHTML:ad];
    
    XCTAssertNotNil(ad.creative.details.media.html);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"<img width='100%' height='100%' src='https://ads.superawesome.tv/v2/demo_images/320x50.jpg' style='object-fit: contain;'/>"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"<a href='http://hotnews.ro'>"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"</a>"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"_MOAT_"]);
    XCTAssertTrue([ad.creative.details.media.html isEqualToString:@"<a href='http://hotnews.ro'><img width='100%' height='100%' src='https://ads.superawesome.tv/v2/demo_images/320x50.jpg' style='object-fit: contain;'/></a>_MOAT_"]);
}

- (void) test_SAProcessHTML_FormatCreativeIntoImageHTML_WithoutClick {
    
    SAAd *ad = [[SAAd alloc] init];
    ad.creative.format = SA_Image;
    ad.creative.details.image = @"https://ads.superawesome.tv/v2/demo_images/320x50.jpg";
    ad.creative.details.media.html = [SAProcessHTML formatCreativeIntoImageHTML:ad];
    
    XCTAssertNotNil(ad.creative.details.media.html);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"<img width='100%' height='100%' src='https://ads.superawesome.tv/v2/demo_images/320x50.jpg' style='object-fit: contain;'/>"]);
    XCTAssertFalse([ad.creative.details.media.html containsString:@"<a href='http://hotnews.ro'>"]);
    XCTAssertFalse([ad.creative.details.media.html containsString:@"</a>"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"_MOAT_"]);
    XCTAssertTrue([ad.creative.details.media.html isEqualToString:@"<img width='100%' height='100%' src='https://ads.superawesome.tv/v2/demo_images/320x50.jpg' style='object-fit: contain;'/>_MOAT_"]);
}

- (void) test_SAProcessHTML_FormatCreativeIntoRichMediaHTML {
    
    SAAd *ad = [[SAAd alloc] init];
    ad.placementId = 4091;
    ad.lineItemId = 2001;
    ad.creative._id = 2081;
    ad.creative.format = SA_Rich;
    ad.creative.details.url = @"https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/rich-media/tNmFLJ7kGQWBbyORkIqTJ4oqykaGPU9w/rich-media/index.html";
    ad.creative.details.media.html = [SAProcessHTML formatCreativeIntoRichMediaHTML:ad withRandom:123456];
    
    XCTAssertNotNil(ad.creative.details.media.html);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"_MOAT_"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"<iframe style='padding:0;margin:0;border:0;' width='100%' height='100%' src='https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/rich-media/tNmFLJ7kGQWBbyORkIqTJ4oqykaGPU9w/rich-media/index.html?creative=2081&line_item=2001&placement=4091&rnd=123456'></iframe>_MOAT_"]);
}

- (void) test_SAProcessHTML_FormatCreativeIntoTagHTML1 {
    
    SAAd *ad = [[SAAd alloc] init];
    ad.creative.format = SA_Tag;
    ad.creative.details.tag = @"<!-- Beginning PassBack for Ad unit FK:Site-Skyscraper-Passback ### size: [[120,600]] -->\\\\n\\\\t<script type='text/javascript' src='http://www.googletagservices.com/tag/js/gpt.js'>\\\\n\\\\t\\\\tgoogletag.pubads().definePassback('1002534/FK:Site-Skyscraper-Passback', [[120,600]]).display();\\\\n\\\\t</script>\\\\n<!-- End Passback -->";
    ad.creative.details.media.html = [SAProcessHTML formatCreativeIntoTagHTML:ad];
    
    XCTAssertNotNil(ad.creative.details.media.html);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"_MOAT_"]);
//    XCTAssertTrue([ad.creative.details.media.html containsString:@"<!-- Beginning PassBack for Ad unit FK:Site-Skyscraper-Passback ### size: [[120,600]] -->\\<script type='text/javascript' src='http://www.googletagservices.com/tag/js/gpt.js'>\\\googletag.pubads().definePassback('1002534/FK:Site-Skyscraper-Passback', [[120,600]]).display();\\</script>\<!-- End Passback -->"]);
    
}

- (void) test_SAProcessHTML_FormatCreativeIntoTagHTML2 {
    
    SAAd *ad = [[SAAd alloc] init];
    ad.creative.format = SA_Tag;
    ad.creative.details.tag = @"<A HREF=\"[click]https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729?\"><IMG SRC=\"https://ad.doubleclick.net/ddm/ad/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729;dc_lat=;dc_rdid=;tag_for_child_directed_treatment=?\" BORDER=0 WIDTH=480 HEIGHT=320 ALT=\"Advertisement\"></A>";
    ad.creative.details.media.html = [SAProcessHTML formatCreativeIntoTagHTML:ad];
    
    XCTAssertNotNil(ad.creative.details.media.html);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"<IMG SRC=\"https://ad.doubleclick.net/ddm/ad/N304202.1915243SUPERAWESOME.TV"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"_MOAT_"]);
    XCTAssertFalse([ad.creative.details.media.html containsString:@"[click]"]);
}

- (void) test_SAProcessHTML_FormatCreativeIntoTagHTML3 {
    
    SAAd *ad = [[SAAd alloc] init];
    ad.creative.format = SA_Tag;
    ad.creative.clickUrl = @"http://hotnews.ro";
    ad.creative.details.tag = @"<A HREF=\"[click]https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729?\"><IMG SRC=\"https://ad.doubleclick.net/ddm/ad/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729;dc_lat=;dc_rdid=;tag_for_child_directed_treatment=?\" BORDER=0 WIDTH=480 HEIGHT=320 ALT=\"Advertisement\"></A>";
    ad.creative.details.media.html = [SAProcessHTML formatCreativeIntoTagHTML:ad];
    
    XCTAssertNotNil(ad.creative.details.media.html);
//    XCTAssertTrue([ad.creative.details.media.html containsString:@"http://hotnews.ro&redir="]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV"]);
//    XCTAssertTrue([ad.creative.details.media.html containsString:@"http://hotnews.ro?redir=https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"<IMG SRC=\"https://ad.doubleclick.net/ddm/ad/N304202.1915243SUPERAWESOME.TV"]);
    XCTAssertTrue([ad.creative.details.media.html containsString:@"_MOAT_"]);
    XCTAssertFalse([ad.creative.details.media.html containsString:@"[click]"]);
}


@end
