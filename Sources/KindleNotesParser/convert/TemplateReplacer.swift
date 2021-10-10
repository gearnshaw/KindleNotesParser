//
//  TemplateReplacer.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 05/10/2021.
//

import Foundation

enum TemplateTags: String, CaseIterable {
    case sectionHeading
    case highlightedText
    case noteText
    case location
    case page
    case timestamp
    case noteDateStamp
    case bookLink
}

protocol TemplateValueProvider {
    func getValue(for templateTag: String) -> String?
}

protocol TemplateReplacer {
    func replace(template: String, with valueProviders: [TemplateValueProvider]) -> String
}

struct SimpleTemplateReplacer: TemplateReplacer {
    func replace(template: String, with valueProviders: [TemplateValueProvider]) -> String {
        return TemplateTags.allCases.reduce(template) { retval, tag in
            let value = valueProviders
                .compactMap { $0.getValue(for: tag.rawValue) }
                .first
            let tagStr = "{{\(tag.rawValue)}}"
            return retval.replacingOccurrences(of: tagStr, with: value ?? "")
        }
    }
}
