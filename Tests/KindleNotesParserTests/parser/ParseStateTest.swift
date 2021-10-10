//
//  ParseStateTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import XCTest
@testable import KindleNotesParser

class ParseStateTest: XCTestCase {
    private var parseState: ParseState!

    override func setUpWithError() throws {
        parseState = ParseState()
    }

    func test_createNoteAndFlush_shouldCreateANote_withNoteText_whenCorrectValuesAreCached() {
        // Given
        let expectedNote = NoteBuilder()
            .makeWithNoteText()
            .build()
        let resetType = ParseState.ResetType.section

        parseState.currentSectionHeading = expectedNote.sectionHeading
        parseState.currentNoteContext = expectedNote.noteContext
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)

        // When
        let actual = parseState.createNoteAndFlush(reset: resetType)

        // Then
        XCTAssertEqual(actual, expectedNote)
    }

    func test_createNoteAndFlush_shouldCreateANote_withoutNoteText_whenCorrectValuesAreCached() {
        // Given
        let expectedNote = NoteBuilder()
            .makeWithoutNoteText()
            .build()
        let resetType = ParseState.ResetType.highlight

        parseState.currentSectionHeading = expectedNote.sectionHeading
        parseState.currentNoteContext = expectedNote.noteContext
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)

        // When
        let actual = parseState.createNoteAndFlush(reset: resetType)

        // Then
        XCTAssertEqual(actual, expectedNote)
    }

    func test_createNoteAndFlush_shouldClearAllValues_whenSectionIsReset() {
        // Given
        let expectedNote = NoteBuilder()
            .makeWithNoteText()
            .build()
        let resetType = ParseState.ResetType.section

        parseState.currentSectionHeading = expectedNote.sectionHeading
        parseState.currentNoteContext = expectedNote.noteContext
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)

        // When
        let _ = parseState.createNoteAndFlush(reset: resetType)

        // Then
        XCTAssertNil(parseState.currentSectionHeading)
        XCTAssertNil(parseState.currentNoteContext)
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)
    }

    func test_createNoteAndFlush_shouldClearNoteValues_whenHighlightIsReset() {
        // Given
        let expectedNote = NoteBuilder()
            .makeWithNoteText()
            .build()
        let resetType = ParseState.ResetType.highlight

        parseState.currentSectionHeading = expectedNote.sectionHeading
        parseState.currentNoteContext = expectedNote.noteContext
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)

        // When
        let _ = parseState.createNoteAndFlush(reset: resetType)

        // Then
        XCTAssertNil(parseState.currentNoteContext)
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)
    }

    func test_createNoteAndFlush_shouldRetainSectionHeading_whenHighlightIsReset() {
        // Given
        let expectedNote = NoteBuilder()
            .makeWithNoteText()
            .build()
        let resetType = ParseState.ResetType.highlight

        parseState.currentSectionHeading = expectedNote.sectionHeading
        parseState.currentNoteContext = expectedNote.noteContext
        parseState.test_addHighlightText(text: expectedNote.highlightedText)
        parseState.test_addNoteText(text: expectedNote.noteText)

        // When
        let _ = parseState.createNoteAndFlush(reset: resetType)

        // Then
        XCTAssertNotNil(parseState.currentSectionHeading)
        XCTAssertEqual(parseState.currentSectionHeading, expectedNote.sectionHeading)
    }
}

// MARK: - Private helper functions
private extension ParseState {
    func test_addNoteText(text: String?) {
        currentNoteType = .note
        if let text = text {
            addNoteOrHighlightText(text: text)
        }
    }

    func test_addHighlightText(text: String) {
        currentNoteType = .highlight
        addNoteOrHighlightText(text: text)
    }
}
