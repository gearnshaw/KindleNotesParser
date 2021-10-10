//
//  NoteType.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 02/10/2021.
//

import Foundation

enum NoteType {
    case highlight
    case note

    static func from(noteHeading: String) -> NoteType? {
        if noteHeading.starts(with: "Highlight") {
            return highlight
        } else if noteHeading.starts(with: "Note") {
            return note
        } else {
            print("Did not find note type for: \(noteHeading)")
            return nil
        }
    }
}
