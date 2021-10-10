//
//  LiteratureNoteGeneratorTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 10/10/2021.
//

import XCTest
@testable import KindleNotesParser

class LiteratureNoteGeneratorTest: XCTestCase {

    func test_generateFrom_shouldInsertNoteValues() {
        // Given
        let expectedPage = 18
        let expectedLocation = 28475
        let noteContext = NoteContextBuilder()
            .with(page: expectedPage)
            .with(location: expectedLocation)
            .build()

        let expectedHighlightedText = "one two three four five once i caught"
        let expectedNoteText: String? = nil
        let note = NoteBuilder()
            .with(highlightedText: expectedHighlightedText)
            .with(noteText: expectedNoteText)
            .with(noteContext: noteContext)
            .build()

        let template = """
        Some text like this {{page}} {{location}}
        {{highlightedText}} {{noteText}}should be empty
        this is lovely
        """

        let globalProviders: [TemplateValueProvider] = []
        let generator = LiteratureNoteGenerator(template: template,
                                                globalValueProviders: globalProviders)

        let expected = """
        Some text like this \(expectedPage) \(expectedLocation)
        \(expectedHighlightedText) should be empty
        this is lovely
        """

        // When
        let actual = generator.generateFrom(note: note)

        // Then
        XCTAssertEqual(actual, expected)
    }

    func test_generateFrom_shouldInsertGlobalValues() {
        // Given
        let note = NoteBuilder()
            .build()

        let mock1 = MockTemplateValueProvider()
        mock1.getValue_retval = nil

        let expectedValue = "some value like this"
        let mock2 = MockTemplateValueProvider()
        mock2.getValue_retval = expectedValue

        let template = """
        Some text like this {{bookLink}} {{noteDateStamp}}
        {{timestamp}} should be empty
        this is lovely
        """

        let globalProviders: [TemplateValueProvider] = [mock1, mock2]
        let generator = LiteratureNoteGenerator(template: template,
                                                globalValueProviders: globalProviders)

        let expected = """
        Some text like this \(expectedValue) \(expectedValue)
        \(expectedValue) should be empty
        this is lovely
        """

        // When
        let actual = generator.generateFrom(note: note)

        // Then
        XCTAssertEqual(actual, expected)
    }

    func test_generateFrom_shouldUseNoteValues_beforeGlobalValues() {
        // Given
        let expectedPage = 18
        let expectedLocation = 28475
        let noteContext = NoteContextBuilder()
            .with(page: expectedPage)
            .with(location: expectedLocation)
            .build()

        let expectedHighlightedText = "one two three four five once i caught"
        let note = NoteBuilder()
            .with(highlightedText: expectedHighlightedText)
            .with(noteContext: noteContext)
            .build()

        let template = """
        Some text like this {{page}} {{location}}
        {{highlightedText}} will appear here
        this is lovely
        """

        let mock1 = MockTemplateValueProvider()
        mock1.getValue_retval = "This shouldn't appear in the output"

        let globalProviders: [TemplateValueProvider] = [mock1]
        let generator = LiteratureNoteGenerator(template: template,
                                                globalValueProviders: globalProviders)

        let expected = """
        Some text like this \(expectedPage) \(expectedLocation)
        \(expectedHighlightedText) will appear here
        this is lovely
        """

        // When
        let actual = generator.generateFrom(note: note)

        // Then
        XCTAssertEqual(actual, expected)
    }

    func test_generateFrom_shouldGenerateExpectedOutput() {
        // Given
        let expectedPage = 18
        let expectedLocation = 28475
        let noteContext = NoteContextBuilder()
            .with(page: expectedPage)
            .with(location: expectedLocation)
            .build()

        let expectedHighlightedText = "one two three four five once i caught"
        let expectedNoteText = "I'm the text of the note\n yes I am"
        let expectedSectionHeading = "Fries with mayo"
        let note = NoteBuilder()
            .with(highlightedText: expectedHighlightedText)
            .with(noteText: expectedNoteText)
            .with(noteContext: noteContext)
            .with(sectionHeading: expectedSectionHeading)
            .build()

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = df.date(from: "2021-10-04 20:07") else {
            XCTFail("Date not set up correctly")
            return
        }
        let expectedBookLinkText = "Here's my text"
        let expectedDateStamp = "4 Oct 2021 at 20:07"
        let expectedTimeStamp = "202110042007"

        let globalProvider = GlobalValueProviderBuilder()
            .with(date: date)
            .with(bookLink: expectedBookLinkText)
            .build()

        let template = getSampleTemplate()

        let generator = LiteratureNoteGenerator(template: template,
                                                globalValueProviders: [globalProvider])

        let expected = getExpectedSampleOutput(timestamp: expectedTimeStamp,
                                               bookLinkText: expectedBookLinkText,
                                               page: expectedPage,
                                               location: expectedLocation,
                                               noteText: expectedNoteText,
                                               highlightedText: expectedHighlightedText,
                                               sectionHeading: expectedSectionHeading,
                                               noteDateStamp: expectedDateStamp)

        // When
        let actual = generator.generateFrom(note: note)

        // Then
        XCTAssertEqual(actual, expected)
    }
}

private extension LiteratureNoteGeneratorTest {
    func getSampleTemplate() -> String {
        """
        #
        #import-{{timestamp}}
        #needs-header
        #.slipbox/literature #needs-perm

        ### Book
        {{bookLink}}
        Page: {{page}}
        Location: {{location}}

        ### Note

        {{noteText}}

        > {{highlightedText}}

        ### Section

        {{sectionHeading}}

        ### Footnotes on the source

        [{{noteDateStamp}}]

        ---
        ## Other References
        References to [use `bs` shortcut in bear to create search link]
        """
    }

    func getExpectedSampleOutput(timestamp: String,
                                 bookLinkText: String,
                                 page: Int,
                                 location: Int,
                                 noteText: String,
                                 highlightedText: String,
                                 sectionHeading: String,
                                 noteDateStamp: String) -> String {
        """
        #
        #import-\(timestamp)
        #needs-header
        #.slipbox/literature #needs-perm

        ### Book
        \(bookLinkText)
        Page: \(page)
        Location: \(location)

        ### Note

        \(noteText)

        > \(highlightedText)

        ### Section

        \(sectionHeading)

        ### Footnotes on the source

        [\(noteDateStamp)]

        ---
        ## Other References
        References to [use `bs` shortcut in bear to create search link]
        """
    }
}
