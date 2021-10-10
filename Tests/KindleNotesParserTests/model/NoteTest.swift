//
//  NoteTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 02/10/2021.
//

import XCTest
@testable import KindleNotesParser

class NoteTest: XCTestCase {

    // MARK: - Failable initialiser tests

    func test_init_shouldFail_whenSectionHeaderIsNil() {
        // Given
        let sectionHeading: String? = nil
        let noteContext = NoteContextBuilder().build()
        let highlightedText = "Here is some text"
        let noteText = "A different piece of text"
        
        // When
        let actual = Note(sectionHeading: sectionHeading,
                          noteContext: noteContext,
                          highlightedText: highlightedText,
                          noteText: noteText)
        
        // Then
        XCTAssertNil(actual)
    }

    func test_init_shouldFail_whenNoteContextIsNil() {
        // Given
        let sectionHeading = "This is the section heading"
        let noteContext: NoteContext? = nil
        let highlightedText = "Here is some text"
        let noteText = "A different piece of text"

        // When
        let actual = Note(sectionHeading: sectionHeading,
                          noteContext: noteContext,
                          highlightedText: highlightedText,
                          noteText: noteText)

        // Then
        XCTAssertNil(actual)
    }

    func test_init_shouldFail_whenHighlightedTextIsNil() {
        // Given
        let sectionHeading = "This is the section heading"
        let noteContext = NoteContextBuilder().build()
        let highlightedText: String? = nil
        let noteText = "A different piece of text"

        // When
        let actual = Note(sectionHeading: sectionHeading,
                          noteContext: noteContext,
                          highlightedText: highlightedText,
                          noteText: noteText)

        // Then
        XCTAssertNil(actual)
    }

    func test_init_shouldCreateNote_whenNoteTextIsNil() {
        // Given
        let sectionHeading = "This is the section heading"
        let noteContext = NoteContextBuilder().build()
        let highlightedText = "Here is some text"
        let noteText: String? = nil

        // When
        let actual = Note(sectionHeading: sectionHeading,
                          noteContext: noteContext,
                          highlightedText: highlightedText,
                          noteText: noteText)

        // Then
        XCTAssertEqual(actual.sectionHeading, sectionHeading)
        XCTAssertEqual(actual.noteContext.page, noteContext.page)
        XCTAssertEqual(actual.noteContext.location, noteContext.location)
        XCTAssertEqual(actual.highlightedText, highlightedText)
        XCTAssertNil(actual.noteText)
    }

    func test_init_shouldCreateNote_whenNoteTextIsPresent() {
        // Given
        let sectionHeading = "This is the section heading"
        let noteContext = NoteContextBuilder().build()
        let highlightedText = "Here is some text"
        let noteText = "A different piece of text"

        // When
        let actual = Note(sectionHeading: sectionHeading,
                          noteContext: noteContext,
                          highlightedText: highlightedText,
                          noteText: noteText)

        // Then
        XCTAssertEqual(actual.sectionHeading, sectionHeading)
        XCTAssertEqual(actual.noteContext.page, noteContext.page)
        XCTAssertEqual(actual.noteContext.location, noteContext.location)
        XCTAssertEqual(actual.highlightedText, highlightedText)
        XCTAssertEqual(actual.noteText, noteText)
    }
}
