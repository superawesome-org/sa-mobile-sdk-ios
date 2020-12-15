//
//  HtmlFormatterTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class HtmlFormatterTests: XCTestCase {
    func test_formatImage_withLink() throws {
        // Given
        let imageLink = "https://www.superawesome.com/"
        let formatter = HtmlFormatter(numberGenerator: NumberGeneratorMock(10), encoder: EncoderMock())
        
        // When
        let result = formatter.formatImageIntoHtml(MockFactory.makeAdWithImageLink(imageLink))
        
        // Then
        expect("<a href='https://www.superawesome.com/' target='_blank'><img src='image' width='100%' height='100%' style='object-fit: contain;'/></a>").to(equal(result))
    }
    
    func test_formatImage_withoutLink() throws {
        // Given
        let formatter = HtmlFormatter(numberGenerator: NumberGeneratorMock(10), encoder: EncoderMock())
        
        // When
        let result = formatter.formatImageIntoHtml(MockFactory.makeAdWithImageLink(nil))
        
        // Then
        expect("<img src='image' width='100%' height='100%' style='object-fit: contain;'/>").to(equal(result))
    }
    
    func  test_formatMedia() throws {
        // Given
        let placementId = 10
        let formatter = HtmlFormatter(numberGenerator: NumberGeneratorMock(10), encoder: EncoderMock())
        
        // When
        let result = formatter.formatRichMediaIntoHtml(placementId, MockFactory.makeAd())
        
        // Then
        expect("<iframe style='padding:0;border:0;' width='100%' height='100%' src='detailurl?placement=\(placementId)&line_item=50&creative=80&rnd=10'></iframe>").to(equal(result))
    }
    
    func test_formatTag() throws {
        // Given
        let tag = "<A HREF=\"[click]https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729?\"><IMG SRC=\"https://ad.doubleclick.net/ddm/ad/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729;dc_lat=;dc_rdid=;tag_for_child_directed_treatment=?\" BORDER=0 WIDTH=480 HEIGHT=320 ALT=\"Advertisement\"></A>"
        let url = "someurl"
        let formatter = HtmlFormatter(numberGenerator: NumberGeneratorMock(10), encoder: EncoderMock())
        
        // When
        let result = formatter.formatTagIntoHtml(MockFactory.makeAdWithTagAndClickUrl(tag, url))
        
        // Then
        expect(#"<A HREF="someurl&redir=https://ad.doubleclick.net/ddm/jump/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729?"><IMG SRC="https://ad.doubleclick.net/ddm/ad/N304202.1915243SUPERAWESOME.TV/B10773905.144955457;sz=480x320;ord=1486394166729;dc_lat=;dc_rdid=;tag_for_child_directed_treatment=?" BORDER=0 WIDTH=480 HEIGHT=320 ALT="Advertisement"></A>"#).to(equal(result))
    }
}
