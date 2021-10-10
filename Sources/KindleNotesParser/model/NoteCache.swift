//
//  NoteCache.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation

class NoteCache {
    var notes: [Note] = []

    var highlightsOnly: [Note] {
        return notes.filter { note in
            note.noteText == nil
        }
    }

    var notesOnly: [Note] {
        return notes.filter { note in
            note.noteText != nil
        }
    }
}

// MARK: - ParseManagerDelegate
extension NoteCache: ParseManagerDelegate {
    func parseManager(_ parseManager: ParseManager, didCreate note: Note) {
        notes.append(note)
    }
}
