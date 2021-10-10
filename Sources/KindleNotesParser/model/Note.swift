//
//  Note.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 02/10/2021.
//

import Foundation

struct NoteContext: Equatable {
    let page: Int
    let location: Int
}

extension NoteContext {
    init?(page: Int?, location: Int?) {
        guard
            let page = page,
            let location = location
        else {
            return nil
        }

        self.init(page: page, location: location)
    }
}

struct Note: Equatable {
    let sectionHeading: String
    let noteContext: NoteContext
    let highlightedText: String
    let noteText: String?
}

extension Note {
    init?(sectionHeading: String?,
          noteContext: NoteContext?,
          highlightedText: String?,
          noteText: String?) {
        guard
            let sectionHeading = sectionHeading,
            let noteContext = noteContext,
            let highlightedText = highlightedText
        else {
            return nil
        }

        self.init(sectionHeading: sectionHeading,
             noteContext: noteContext,
             highlightedText: highlightedText,
             noteText: noteText)
    }
}
