//
//  ContextParser.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation

protocol ContextParser {
    func parseContext(noteHeading: String) -> NoteContext?
}

extension ContextParser {
    func parseContext(noteHeading: String) -> NoteContext? {
        let page = extractPage(text: noteHeading)
        let location = extractLocation(text: noteHeading)
        return NoteContext(page: page, location: location)
    }
}

private extension ContextParser {
    func extractPage(text: String) -> Int? {
        return extractValue(withHeader: "Page", from: text)
    }

    func extractLocation(text: String) -> Int? {
        return extractValue(withHeader: "Location", from: text)
    }

    private func extractValue(withHeader matchText: String, from text: String) -> Int? {
        guard let matchedText = extractMatchedText(text: text, matchText: matchText) else {
            return nil
        }
        return extractNumber(valueSnippet: matchedText)
    }

    private func extractMatchedText(text: String, matchText: String) -> String? {
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\(matchText) [0-9]+")

        guard let match = regex.firstMatch(in: text, options: [], range: range) else {
            return nil
        }

        guard let range = Range(match.range, in: text) else {
            return nil
        }

        return String(text[range])
    }

    private func extractNumber(valueSnippet: String) -> Int? {
        let tokens = valueSnippet.split(separator: " ")
        guard tokens.count == 2 else {
            print("Expected 2 tokens but found \(tokens.count)")
            return nil
        }

        let numberToken = tokens[1]
        return Int(numberToken)
    }
}
