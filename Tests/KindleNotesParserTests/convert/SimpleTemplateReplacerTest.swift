//
//  SimpleTemplateReplacerTest.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 05/10/2021.
//

import XCTest
@testable import KindleNotesParser

class SimpleTemplateReplacerTest: XCTestCase {
    private var templateReplacer: SimpleTemplateReplacer!

    override func setUpWithError() throws {
        templateReplacer = SimpleTemplateReplacer()
    }
}

// MARK :- Template tags tests
extension SimpleTemplateReplacerTest {
    func test_replaceText_shouldQueryValues_forAllKnownTemplateTag() {
        // Given
        let text: String = .someString
        let mockProvider = MockTemplateValueProvider()

        // When
        let _ = templateReplacer.replace(template: text, with: [mockProvider])

        // Then
        XCTAssertEqual(mockProvider.getValue_calledWith, TemplateTags.allCases.map {$0.rawValue})
    }

    func test_replaceText_shouldReplaceATemplateTag() {
        // Given
        let startOfString: String = .someString
        let endOfString: String = .someString
        let mockProvider = MockTemplateValueProvider()
        let tag = TemplateTags.noteText.rawValue

        let templateString = startOfString + "{{\(tag)}}" + endOfString
        let expectedString = "Some text to put in the string"
        mockProvider.getValue_retval = expectedString

        // When
        let actual = templateReplacer.replace(template: templateString, with: [mockProvider])

        // Then
        XCTAssertEqual(actual, startOfString + expectedString + endOfString)
    }

    func test_replaceText_shouldNotReplace_unknownTag() {
        // Given
        let mockProvider = MockTemplateValueProvider()
        let templateString = "asdfasdf {{notATag}} sfsdf"

        // When
        let actual = templateReplacer.replace(template: templateString, with: [mockProvider])

        // Then
        XCTAssertEqual(actual, templateString)
    }

    func test_replaceText_shouldReplaceTagWithNoValue_withEmptyString() {
        // Given
        let startOfString: String = .someString
        let endOfString: String = .someString
        let mockProvider = MockTemplateValueProvider()
        let tag = TemplateTags.noteText.rawValue

        let templateString = startOfString + "{{\(tag)}}" + endOfString
        let expectedString = ""
        mockProvider.getValue_retval = nil

        // When
        let actual = templateReplacer.replace(template: templateString, with: [mockProvider])

        // Then
        XCTAssertEqual(actual, startOfString + expectedString + endOfString)
    }

    func test_replaceText_shouldReplaceMultipleTemplateTags_inOneTemplate() {
        // Given
        let startOfString: String = .someString
        let endOfString: String = .someString
        let mockProvider = MockTemplateValueProvider()
        let value = "this is the replacement"
        mockProvider.getValue_retval = value

        let templateString = startOfString
            + "{{\(TemplateTags.noteText.rawValue)}}"
            + "{{\(TemplateTags.location.rawValue)}}"
            + "{{\(TemplateTags.page.rawValue)}}"
            + "{{\(TemplateTags.timestamp.rawValue)}}"
            + endOfString

        let expectedString = startOfString
            + value
            + value
            + value
            + value
            + endOfString

        // When
        let actual = templateReplacer.replace(template: templateString, with: [mockProvider])

        // Then
        XCTAssertEqual(actual, expectedString)
    }

    func test_replaceText_shouldReplaceMultipleInstances_ofTheSameTemplateTags() {
        // Given
        let startOfString: String = .someString
        let endOfString: String = .someString
        let mockProvider = MockTemplateValueProvider()
        let value = "this is the replacement"
        mockProvider.getValue_retval = value

        let templateString = startOfString
            + "{{\(TemplateTags.location.rawValue)}}"
            + "{{\(TemplateTags.location.rawValue)}}"
            + "{{\(TemplateTags.location.rawValue)}}"
            + "{{\(TemplateTags.location.rawValue)}}"
            + endOfString

        let expectedString = startOfString
            + value
            + value
            + value
            + value
            + endOfString

        // When
        let actual = templateReplacer.replace(template: templateString, with: [mockProvider])

        // Then
        XCTAssertEqual(actual, expectedString)
    }
}

// MARK: - tests with multiple providers
extension SimpleTemplateReplacerTest {
    func test_replaceText_shouldChooseTheFirstNoneNilValue() {
        // Given
        let expectedValue = "This is the one"
        let mockProviders = getMocks(with: [expectedValue, "Value 2", "Value3"])
        let templateString = "{{\(TemplateTags.highlightedText)}}"

        // When
        let actual = templateReplacer.replace(template: templateString, with: mockProviders)

        // Then
        XCTAssertEqual(actual, expectedValue)
    }

    func test_replaceText_shouldChooseTheSecondValue_whenTheFirstIsNil() {
        // Given
        let expectedValue = "This is the one"
        let mockProviders = getMocks(with: [nil, expectedValue, "Value 2", "Value3"])
        let templateString = "{{\(TemplateTags.highlightedText)}}"

        // When
        let actual = templateReplacer.replace(template: templateString, with: mockProviders)

        // Then
        XCTAssertEqual(actual, expectedValue)
    }

    func test_replaceText_shouldChooseTheLastValue_whenThePreviousAreNil() {
        // Given
        let expectedValue = "This is the one"
        let mockProviders = getMocks(with: [nil, nil, expectedValue])
        let templateString = "{{\(TemplateTags.highlightedText)}}"

        // When
        let actual = templateReplacer.replace(template: templateString, with: mockProviders)

        // Then
        XCTAssertEqual(actual, expectedValue)
    }

    func test_replaceText_shouldReturnEmptyString_whenAllValueProvidersReturnNil() {
        // Given
        let expectedValue = ""
        let mockProviders = getMocks(with: [nil, nil, nil])
        let templateString = "{{\(TemplateTags.highlightedText)}}"

        // When
        let actual = templateReplacer.replace(template: templateString, with: mockProviders)

        // Then
        XCTAssertEqual(actual, expectedValue)
    }
}

// MARK: - private helper functions
private extension SimpleTemplateReplacerTest {
    func getMocks(with values: [String?]) -> [MockTemplateValueProvider] {
        return values.map {
            let mock = MockTemplateValueProvider()
            mock.getValue_retval = $0
            return mock
        }
    }
}

class MockTemplateValueProvider: TemplateValueProvider {
    var getValue_retval: String? = nil
    var getValue_calledWith: [String] = []
    func getValue(for templateTag: String) -> String? {
        getValue_calledWith.append(templateTag)
        return getValue_retval
    }

}
