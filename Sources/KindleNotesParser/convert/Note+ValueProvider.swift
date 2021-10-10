//
//  Note+ValueProvider.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 06/10/2021.
//

import Foundation

extension Note: TemplateValueProvider {
    func getValue(for templateTag: String) -> String? {
        guard let tag = TemplateTags(rawValue: templateTag) else {
            return nil
        }

        switch tag {
        case .noteText:
            return noteText
        case .sectionHeading:
            return sectionHeading
        case .highlightedText:
            return highlightedText
        case .location:
            return "\(noteContext.location)"
        case .page:
            return "\(noteContext.page)"
        case .timestamp,
                .noteDateStamp,
                .bookLink:
            return nil
        }
    }
}
