//
//  ParseState.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation

class ParseState {
    var currentSectionHeading: String?
    var currentNoteContext: NoteContext?
    var currentNoteType = NoteType.highlight
    private var currentHighlightedText: String?
    private var currentNoteText: String?

    enum ResetType {
        case section
        case highlight
    }

    func createNoteAndFlush(reset: ResetType) -> Note? {
        let note = Note(sectionHeading: currentSectionHeading,
                    noteContext: currentNoteContext,
                    highlightedText: currentHighlightedText,
                    noteText: currentNoteText)
        resetState(resetType: reset)
        return note
    }

    func addNoteOrHighlightText(text: String) {
        switch currentNoteType {
        case .highlight:
            currentHighlightedText = text
        case .note:
            currentNoteText = text
        }
    }
}

// MARK: - private helper functions
private extension ParseState {
    func resetState(resetType: ResetType) {
        currentNoteContext = nil
        currentHighlightedText = nil
        currentNoteText = nil

        if resetType == .section {
            currentSectionHeading = nil
        }
    }
}
