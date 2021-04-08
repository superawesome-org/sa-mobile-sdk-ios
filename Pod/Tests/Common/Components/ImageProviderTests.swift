//
//  ImageProviderTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gabriel Coman on 15/12/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class ImageProviderTests: XCTestCase {

    func test_bumperPoweredByImage_returns_an_image_object() {
        // given
        let provider: ImageProviderType = ImageProvider()

        // when
        let result = provider.bumperPoweredByImage

        // then
        expect(result).toNot(beNil())
    }

    func test_bumperBackgroundImage_returns_an_image_object() {
        // given
        let provider: ImageProviderType = ImageProvider()

        // when
        let result = provider.bumperBackgroundImage

        // then
        expect(result).toNot(beNil())
    }

    func test_closeImage_returns_an_image_object() {
        // given
        let provider: ImageProviderType = ImageProvider()

        // when
        let result = provider.closeImage

        // then
        expect(result).toNot(beNil())
    }

    func test_safeAdImage_returns_an_image_object() {
        // given
        let provider: ImageProviderType = ImageProvider()

        // when
        let result = provider.safeAdImage

        // then
        expect(result).toNot(beNil())
    }
}
