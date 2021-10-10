//
//  GlobalValueProviderTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 09/10/2021.
//

import XCTest
@testable import KindleNotesParser

class GlobalValueProviderTest: XCTestCase {
    private let supportedTags: [TemplateTags] = [.timestamp,
                                                 .noteDateStamp,
                                                 .bookLink]

    func test_getValue_shouldReturnValues_forAllExpectedTagTypes() {
        // Given
        let provider = GlobalValueProviderBuilder()
            .build()

        for tag in supportedTags {
            // When
            let actual = provider.getValue(for: tag.rawValue)

            // Then
            XCTAssertNotNil(actual)
        }
    }

    func test_getValue_shouldReturnCorrectValues_forTagTypes() {
        // Given
        let components = DateComponents(year: 2021, month: 10, day: 4, hour: 20, minute: 7)
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else {
            XCTFail("Date not set up correctly")
            return
        }
        let expectedBookLink = "[[Book:MuBook]]"

        let provider = GlobalValueProviderBuilder()
            .with(date: date)
            .with(bookLink: expectedBookLink)
            .build()

        let expectedDateStamp = "4 Oct 2021 at 20:07"
        let expectedTimeStamp = "202110042007"
        let expectedValues: [TemplateTags: String] = [.noteDateStamp: expectedDateStamp,
                                                      .timestamp: expectedTimeStamp,
                                                      .bookLink: expectedBookLink]

        for tag in supportedTags {

            // When
            let actual = provider.getValue(for: tag.rawValue)

            // Then
            guard let expected = expectedValues[tag] else {
                XCTFail("Add expected value for \(tag)")
                return
            }
            XCTAssertEqual(actual, expected)
        }
    }

}
