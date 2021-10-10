//
//  NoteBuilder.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation
@testable import KindleNotesParser

class NoteBuilder {
    private var sectionHeading = "I'm a section heading"
    private var noteContext = NoteContextBuilder().build()
    private var highlightedText = "Some highlighted text"
    private var noteText: String? = "I've got note text"

    func makeWithNoteText() -> Self {
        noteText = "explicitly added note text"
        return self
    }

    func makeWithoutNoteText() -> Self {
        noteText = nil
        return self
    }

    func with(sectionHeading: String) -> Self {
        self.sectionHeading = sectionHeading
        return self
    }

    func with(noteContext: NoteContext) -> Self {
        self.noteContext = noteContext
        return self
    }

    func with(highlightedText: String) -> Self {
        self.highlightedText = highlightedText
        return self
    }

    func with(noteText: String?) -> Self {
        self.noteText = noteText
        return self
    }

    func build() -> Note {
        return Note(sectionHeading: sectionHeading,
                    noteContext: noteContext,
                    highlightedText: highlightedText,
                    noteText: noteText)
    }
}
