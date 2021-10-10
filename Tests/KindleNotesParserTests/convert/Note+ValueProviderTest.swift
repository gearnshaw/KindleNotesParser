//
//  Note+ValueProviderTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 06/10/2021.
//

import XCTest
@testable import KindleNotesParser

class Note_ValueProviderTest: XCTestCase {
    private let supportedTags = Set(TemplateTags.allCases)
        .subtracting([TemplateTags.timestamp,
                      TemplateTags.noteDateStamp,
                      TemplateTags.bookLink])

    func test_getValue_shouldReturnValues_forAllExpectedTagTypes() {
        // Given
        let note = NoteBuilder()
            .makeWithNoteText()
            .build()

        for tag in supportedTags {
            // When
            let actual = note.getValue(for: tag.rawValue)

            // Then
            XCTAssertNotNil(actual)
        }
    }

    func test_getValue_shouldReturnCorrectValues_forTagTypes() {
        // Given
        let expectedNoteText = "Hello, I am the note text"
        let expectedSectionHeading = "Part 3, Heading of the Sections"
        let expectedPage = 23
        let expectedLocation = 2938
        let expectHighlightedText = "I am text that is highlighted"

        let expectedContext = NoteContextBuilder()
            .with(page: expectedPage)
            .with(location: expectedLocation)
            .build()

        let note = NoteBuilder()
            .with(noteText: expectedNoteText)
            .with(sectionHeading: expectedSectionHeading)
            .with(noteContext: expectedContext)
            .with(highlightedText: expectHighlightedText)
            .build()

        let expectedValues: [TemplateTags: String] = [.noteText: expectedNoteText,
                                                      .sectionHeading: expectedSectionHeading,
                                                      .page: "\(expectedPage)",
                                                      .location: "\(expectedLocation)",
                                                      .highlightedText: expectHighlightedText]

        for tag in supportedTags {

            // When
            let actual = note.getValue(for: tag.rawValue)

            // Then
            guard let expected = expectedValues[tag] else {
                XCTFail("Add expected value for \(tag)")
                return
            }
            XCTAssertNotNil(actual, expected)
        }
    }

}
