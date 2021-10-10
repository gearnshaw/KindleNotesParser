//
//  ContextParserTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import XCTest
@testable import KindleNotesParser

class ContextParserTest: XCTestCase {
    private var parser: ContextParser!

    override func setUpWithError() throws {
        parser = TestContextParser()
    }

    func test_parseContext_shouldReturnAContext_withTheCorrectValues() {
        // Given
        let expectedPage = 50
        let expectedLocation = 624
        let heading = """
        Highlight(<span class="highlight_yellow">yellow</span>) - Chapter 2 - Measuring Performance > Page \(expectedPage) · Location \(expectedLocation)
        """

        // When
        let actual = parser.parseContext(noteHeading: heading)

        // Then
        XCTAssertEqual(actual?.page, expectedPage)
        XCTAssertEqual(actual?.location, expectedLocation)
    }

    func test_parseContext_shouldReturnNil_whenLocationIsMissing() {
        // Given
        let heading = """
        Highlight(<span class="highlight_yellow">yellow</span>) - Chapter 2 - Measuring Performance > Page 50 ·
        """

        // When
        let actual = parser.parseContext(noteHeading: heading)

        // Then
        XCTAssertNil(actual)
    }

    func test_parseContext_shouldReturnNil_whenPageIsMissing() {
        // Given
        let heading = """
        Highlight(<span class="highlight_yellow">yellow</span>) - Chapter 2 - Measuring Performance · Location 254
        """

        // When
        let actual = parser.parseContext(noteHeading: heading)

        // Then
        XCTAssertNil(actual)
    }

}

struct TestContextParser: ContextParser {}
