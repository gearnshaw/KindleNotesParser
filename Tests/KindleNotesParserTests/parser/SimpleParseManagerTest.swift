//
//  SimpleParseManagerTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import XCTest
@testable import KindleNotesParser

class SimpleParseManagerTest: XCTestCase {
    private var parseManager: SimpleParseManager!
    private var mockParseState: MockParseState!
    private var testDelegate: TestParseManagerDelegate!

    override func setUpWithError() throws {
        mockParseState = MockParseState()
        testDelegate = TestParseManagerDelegate()

        parseManager = SimpleParseManager(parseState: mockParseState)
        parseManager.delegate = testDelegate
    }
}

// MARK: - handleSectionHeading tests
extension SimpleParseManagerTest {
    func test_handleSectionHeading_shouldCreateAndFlushState_withSectionResetType() {
        // Given
        let expectedSectionHeading = "Here I am"
        let expectedResetType = ParseState.ResetType.section

        // When
        parseManager.handleSectionHeading(sectionHeading: expectedSectionHeading)

        // Then
        XCTAssertEqual(mockParseState.createNoteAndFlush_calledWith, expectedResetType)
    }

    func test_handleSectionHeading_shouldUpdateSectionHeading() {
            // Given
            let expectedSectionHeading = "Here I am"

            // When
            parseManager.handleSectionHeading(sectionHeading: expectedSectionHeading)

            // Then
            XCTAssertEqual(mockParseState.currentSectionHeading, expectedSectionHeading)
    }

    func test_handleSectionHeading_shouldEmitANote_whenStateFlushReturnsANote() {
        // Given
        let expectedNote = NoteBuilder().build()
        mockParseState.createNoteAndFlush_retval = expectedNote

        // When
        parseManager.handleSectionHeading(sectionHeading: .someString)

        // Then
        XCTAssertEqual(testDelegate.didCreateNote_calledWith, expectedNote)
    }

    func test_handleSectionHeading_shouldNotEmitANote_whenStateFlushDoesNotReturnANote() {
        // Given
        mockParseState.createNoteAndFlush_retval = nil

        // When
        parseManager.handleSectionHeading(sectionHeading: .someString)

        // Then
        XCTAssertNil(testDelegate.didCreateNote_calledWith)
    }
}

// MARK: - handleNoteHeading when heading is Highlight tests
extension SimpleParseManagerTest {
    func test_handleNoteHeading_shouldCreateAndFlushState_withHighlightResetType_whenHeadingIsHighlight() {
        // Given
        let expectedNoteHeading = "Highlight(<span class=\"highlight_yellow\">yellow</span>) - Chapter 2 - Measuring Performance > Page 50 · Location 624"
        let expectedResetType = ParseState.ResetType.highlight

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertEqual(mockParseState.createNoteAndFlush_calledWith, expectedResetType)
    }

    func test_handleNoteHeading_shouldEmitANote_whenHeadingIsHighlight_andStateFlushReturnsANote() {
        // Given
        let expectedNote = NoteBuilder().build()
        let expectedNoteHeading = "Highlight(<span class=\"highlight_yellow\">yellow</span>) - Chapter 2 - Measuring Performance > Page 50 · Location 624"
        mockParseState.createNoteAndFlush_retval = expectedNote

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertEqual(testDelegate.didCreateNote_calledWith, expectedNote)
    }

    func test_handleNoteHeading_shouldNotEmitANote_whenHeadingIsHighlight_andStateFlushDoesNotReturnANote() {
        // Given
        let expectedNoteHeading = "Highlight(<span class=\"highlight_yellow\">yellow</span>) - Chapter 2 - Measuring Performance > Page 50 · Location 624"
        mockParseState.createNoteAndFlush_retval = nil

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertNil(testDelegate.didCreateNote_calledWith)
    }

    func test_handleNoteHeading_shouldUpdateNoteType_whenHeadingIsHighlight() {
        // Given
        let expectedNoteHeading = "Highlight(<span class=\"highlight_yellow\">yellow</span>) - Chapter 2 - Measuring Performance > Page 50 · Location 624"
        mockParseState.currentNoteType = .note

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertEqual(mockParseState.currentNoteType, .highlight)
    }

    func test_handleNoteHeading_shouldUpdateNoteContext_whenHeadingIsHighlight() {
        // Given
        let expectedPage = 34
        let expectedLocation = 2948
        let expectedNoteContext = NoteContextBuilder()
            .with(page: expectedPage)
            .with(location: expectedLocation)
            .build()
        let expectedNoteHeading = "Highlight(<span class=\"highlight_yellow\">yellow</span>) - Chapter 2 - Measuring Performance > Page \(expectedNoteContext.page) · Location \(expectedNoteContext.location)"

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertEqual(mockParseState.currentNoteContext, expectedNoteContext)
    }
}

// MARK: - handleNoteHeading when heading is note tests
extension SimpleParseManagerTest {
    func test_handleNoteHeading_shouldNotCreateAndFlushState_whenHeadingIsNote() {
        // Given
        let expectedNoteHeading = "Note - Chapter 1 - Accelerate > Page 31 · Location 389"

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertEqual(mockParseState.createNoteAndFlush_callCount, 0)
    }

    func test_handleNoteHeading_shouldNotUpdateNoteContext_whenHeadingIsNote() {
        // Given
        let expectedNoteHeading = "Note - Chapter 1 - Accelerate > Page 31 · Location 389"

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertNil(mockParseState.currentNoteContext)
    }

    func test_handleNoteHeading_shouldUpdateNoteType_whenHeadingIsNote() {
        // Given
        let expectedNoteHeading = "Note - Chapter 1 - Accelerate > Page 31 · Location 389"

        mockParseState.currentNoteType = .highlight

        // When
        parseManager.handleNoteHeading(noteHeading: expectedNoteHeading)

        // Then
        XCTAssertEqual(mockParseState.currentNoteType, .note)
    }
}

// MARK: - handleNoteText tests
extension SimpleParseManagerTest {
    func test_handleNoteText_shouldAddNoteText_toParseState() {
        // Given
        let expectedNoteText = "Here is the text"

        // When
        parseManager.handleNoteText(noteText: expectedNoteText)

        // Then
        XCTAssertEqual(mockParseState.addNoteOrHighlightText_calledWith, expectedNoteText)
    }
}

// MARK: - finish tests
extension SimpleParseManagerTest {
    func test_finish_shouldCreateAndFlushState() {
        // Given

        // When
        parseManager.finish()

        // Then
        XCTAssertEqual(mockParseState.createNoteAndFlush_callCount, 1)
    }

    func test_finish_shouldEmitANote_whenStateFlushReturnsANote() {
        // Given
        let expectedNote = NoteBuilder().build()
        mockParseState.createNoteAndFlush_retval = expectedNote

        // When
        parseManager.finish()

        // Then
        XCTAssertEqual(testDelegate.didCreateNote_calledWith, expectedNote)
    }

    func test_finish_shouldNotEmitANote_whenStateFlushDoesNotReturnANote() {
        // Given
        mockParseState.createNoteAndFlush_retval = nil

        // When
        parseManager.finish()

        // Then
        XCTAssertNil(testDelegate.didCreateNote_calledWith)
    }
}

class TestParseManagerDelegate: ParseManagerDelegate {
    var didCreateNote_calledWith: Note?
    func parseManager(_ parseManager: ParseManager, didCreate note: Note) {
        didCreateNote_calledWith = note
    }
}
