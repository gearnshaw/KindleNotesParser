//
//  BearNoteExporterTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 10/10/2021.
//

import XCTest
@testable import KindleNotesParser

class BearNoteExporterTest: XCTestCase {

    func test_export_shouldCallUrlOpener_withTheCorrectUrl() {
        // Given
        let mock = MockUrlOpener()
        let exporter = BearNoteExporter(urlOpener: mock)
        let text = getExpectedSampleOutput()
        let expected = getExpectedUrl()

        // When
        let _ = exporter.export(text: text)

        // Then
        XCTAssertEqual(mock.open_calledWith, expected)
    }

    func test_export_shouldReturnTrue_whenTheExportWasSuccessful() {
        // Given
        let mock = MockUrlOpener()
        mock.open_retval = true
        let exporter = BearNoteExporter(urlOpener: mock)
        let text = getExpectedSampleOutput()

        // When
        let actual = exporter.export(text: text)

        // Then
        XCTAssertTrue(actual)
    }

    func test_export_shouldReturnFalse_whenTheExportWasUnsuccessful() {
        // Given
        let mock = MockUrlOpener()
        mock.open_retval = false
        let exporter = BearNoteExporter(urlOpener: mock)
        let text = getExpectedSampleOutput()

        // When
        let actual = exporter.export(text: text)

        // Then
        XCTAssertFalse(actual)
    }
}

private extension BearNoteExporterTest {
    func getExpectedSampleOutput() -> String {
        """
        #
        #import-123
        #needs-header
        #.slipbox/literature #needs-perm

        ### Book
        [[Book: My Test Book]]
        Page: 11
        Location: 12345
        """
    }
    func getTestSampleOutput() -> String {
        """
        #
        #import-123
        #needs-header
        #.slipbox/literature #needs-perm

        ### Book
        [[Book: My Test Book]]
        Page: 11
        Location: 12345

        ### Note

        Here's an interesting note I made at this location

        > The minds of many are closed to the thoughts of the few

        ### Section

        Some load of nonsense

        ### Footnotes on the source

        [4 Oct etc]

        ---
        ## Other References
        References to [use `bs` shortcut in bear to create search link]
        """
    }

    func getExpectedUrl() -> URL? {
        let urlStr = "bear://x-callback-url/create?text=%23%0A%23import-123%0A%23needs-header%0A%23.slipbox/literature%20%23needs-perm%0A%0A%23%23%23%20Book%0A%5B%5BBook:%20My%20Test%20Book%5D%5D%0APage:%2011%0ALocation:%2012345"
        return URL(string: urlStr)
    }
}

class MockUrlOpener: URLOpening {
    var open_retval = false
    var open_calledWith: URL? = nil
    func open(_ url: URL) -> Bool {
        open_calledWith = url
        return open_retval
    }
}
