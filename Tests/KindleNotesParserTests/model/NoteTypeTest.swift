//
//  NoteTypeTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 02/10/2021.
//

import XCTest
@testable import KindleNotesParser

class NoteTypeTest: XCTestCase {

    // MARK: - from() tests

    func test_from_shouldReturnHighlight() {
        // Given
        let text = """
        Highlight(<span class="highlight_yellow">yellow</span>) - Chapter 1 - Accelerate > Page 31 · Location 387
        """

        // When
        let actual = NoteType.from(noteHeading: text)

        // Then
        XCTAssertEqual(actual, NoteType.highlight)
    }

    func test_from_shouldReturnNote() {
        // Given
        let text = "Note - Chapter 1 - Accelerate > Page 31 · Location 389"

        // When
        let actual = NoteType.from(noteHeading: text)
        
        // Then
        XCTAssertEqual(actual, NoteType.note)
    }

    func test_from_shouldReturnNil_whenHeadingIsBookmark() {
        // Given
        let text = "Bookmark - Chapter 2 - Measuring Performance > Page 42 · Location 545"

        // When
        let actual = NoteType.from(noteHeading: text)

        // Then
        XCTAssertNil(actual)
    }

    func test_from_shouldReturnNil_whenHeadingIsUnknown() {
        // Given
        let text = "Some text that isn't an expected note heading"

        // When
        let actual = NoteType.from(noteHeading: text)

        // Then
        XCTAssertNil(actual)
    }

}
