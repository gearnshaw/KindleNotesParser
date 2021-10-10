//
//  GlobalValueProvider.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 09/10/2021.
//

import Foundation

struct GlobalValueProvider: TemplateValueProvider {
    private let date: Date
    private let bookLink: String
    private let timeStamp: String
    private let noteDateStamp: String

    init(date: Date = Date(),
         bookLink: String) {
        self.date = date

        let dfTimeStamp = DateFormatter()
        dfTimeStamp.dateFormat = "yyyyMMddHHmm" // 202110042007
        timeStamp = dfTimeStamp.string(from: date)

        let dfNoteDateStamp = DateFormatter()
        dfNoteDateStamp.dateFormat = "d MMM yyyy 'at' HH:mm" // 4 Oct 2021 at 20:07
        noteDateStamp = dfNoteDateStamp.string(from: date)

        self.bookLink = bookLink
    }

    func getValue(for templateTag: String) -> String? {
        guard let tag = TemplateTags(rawValue: templateTag) else {
            return nil
        }

        switch tag {
        case .timestamp:
            return timeStamp
        case .noteDateStamp:
            return noteDateStamp
        case .bookLink:
            return bookLink
        case .noteText,
                .sectionHeading,
                .highlightedText,
                .location,
                .page:
            return nil
        }
    }
}
