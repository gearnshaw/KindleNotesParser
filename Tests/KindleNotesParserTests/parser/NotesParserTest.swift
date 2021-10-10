//
//  NotesParserTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import XCTest
@testable import KindleNotesParser

class NotesParserTest: XCTestCase {
    private var noteCache: NoteCache!
    private var noteParser: NotesParser!

    override func setUpWithError() throws {
        noteCache = NoteCache()
        let parseManager = SimpleParseManager()
        parseManager.delegate = noteCache
        noteParser = NotesParser(parseManager: parseManager)
    }
}

// MARK: - parseText tests
extension NotesParserTest {
    func test_parseNotes_shouldParse_correctNumberOfNotes() {
        // Given
        guard
            let html = readTestFileContents(fileName: "test", fileExtension: "html")
        else {
            XCTFail("Error reading test file")
            return
        }

        // When
        noteParser.parseNotes(html: html)

        // Then
        XCTAssertEqual(noteCache.notes.count, 4)
    }

    func test_parseNotes_shouldCorrectlyParse_aHighlight() {
        // Given
        let noteIndex = 0
        let expectedNoteContext = NoteContextBuilder()
            .with(page: 38)
            .with(location: 577)
            .build()
        let expectedNote = NoteBuilder()
            .with(sectionHeading: "Chapter Four")
            .with(noteContext: expectedNoteContext)
            .with(highlightedText: "‘Plus four, plus four, plus five, plus four, plus three, plus three, plus three, plus four, plus three, plus four, plus five–stop! Hole card’s an ace.’")
            .with(noteText: nil)
            .build()

        guard
            let html = readTestFileContents(fileName: "test", fileExtension: "html")
        else {
            XCTFail("Error reading test file")
            return
        }

        // When
        noteParser.parseNotes(html: html)

        // Then
        XCTAssertEqual(noteCache.notes[noteIndex], expectedNote)
    }

    func test_parseNotes_shouldCorrectlyParse_aHighlightWithSingleLineNote() {
        // Given
        let noteIndex = 1

        let expectedNoteContext = NoteContextBuilder()
            .with(page: 63)
            .with(location: 1015)
            .build()
        let expectedNote = NoteBuilder()
            .with(sectionHeading: "Chapter Six")
            .with(noteContext: expectedNoteContext)
            .with(highlightedText: "Instead, he poured money into the conglomerates he knew had thrived through the decade on such investments: Litton, Teledyne, Ling-Temco-Vought.")
            .with(noteText: "This is a test note")
            .build()

        guard
            let html = readTestFileContents(fileName: "test", fileExtension: "html")
        else {
            XCTFail("Error reading test file")
            return
        }

        // When
        noteParser.parseNotes(html: html)

        // Then
        XCTAssertEqual(noteCache.notes[noteIndex], expectedNote)
    }

    // This test is disabled - there is currently an issue with parsing multi-line text
    func xtest_parseNotes_shouldCorrectlyParse_aHighlightWithMultipleLineNote() {
        // Given
        let noteIndex = 3
        let expectedNoteText = """
        Testing testing.

        With text on multiple lines.
        """
        
        let expectedNoteContext = NoteContextBuilder()
            .with(page: 111)
            .with(location: 1857)
            .build()
        let expectedNote = NoteBuilder()
            .with(sectionHeading: "Chapter Ten")
            .with(noteContext: expectedNoteContext)
            .with(highlightedText: "Jeff finished his eggs and bacon as the sun was coming up, scrubbed the dishes, and left the pan to soak.")
            .with(noteText: expectedNoteText)
            .build()

        guard
            let html = readTestFileContents(fileName: "test", fileExtension: "html")
        else {
            XCTFail("Error reading test file")
            return
        }

        // When
        noteParser.parseNotes(html: html)

        // Then
        XCTAssertEqual(noteCache.notes[noteIndex], expectedNote)
    }
}
