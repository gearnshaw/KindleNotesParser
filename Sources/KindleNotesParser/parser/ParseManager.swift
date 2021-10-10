//
//  ParseManager.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation

protocol ParseManagerDelegate {
    func parseManager(_ parseManager: ParseManager, didCreate note: Note)
}

protocol ParseManager {
    var delegate: ParseManagerDelegate? { get set }
    func handleSectionHeading(sectionHeading: String)
    func handleNoteHeading(noteHeading: String)
    func handleNoteText(noteText: String)
    func finish()
}

class SimpleParseManager: ParseManager {
    private let parseState: ParseState

    var delegate: ParseManagerDelegate?

    init(parseState: ParseState = ParseState()) {
        self.parseState = parseState
    }

    func handleSectionHeading(sectionHeading: String) {
        if let note = parseState.createNoteAndFlush(reset: .section) {
            delegate?.parseManager(self, didCreate: note)
        }
        parseState.currentSectionHeading = sectionHeading
    }

    func handleNoteHeading(noteHeading: String) {
        guard let noteType = NoteType.from(noteHeading: noteHeading) else { return }

        switch noteType {
        case .note:
            handleNote()
        case .highlight:
            handleHighlight(noteHeading: noteHeading)
        }
    }

    func handleNoteText(noteText: String) {
        parseState.addNoteOrHighlightText(text: noteText)
    }

    func finish() {
        if let note = parseState.createNoteAndFlush(reset: .section) {
            delegate?.parseManager(self, didCreate: note)
        }
    }
}

// MARK: - Context parsing functionality
extension SimpleParseManager: ContextParser {}


private extension SimpleParseManager {
    func handleNote() {
        parseState.currentNoteType = .note
    }

    func handleHighlight(noteHeading: String) {
        if let note = parseState.createNoteAndFlush(reset: .highlight) {
            delegate?.parseManager(self, didCreate: note)
        }

        parseState.currentNoteType = .highlight
        let noteContext = parseContext(noteHeading: noteHeading)
        parseState.currentNoteContext = noteContext
    }
}
