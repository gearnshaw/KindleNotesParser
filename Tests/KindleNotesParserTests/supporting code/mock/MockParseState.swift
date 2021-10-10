//
//  MockParseState.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation
@testable import KindleNotesParser

class MockParseState: ParseState {
    var createNoteAndFlush_callCount = 0
    var createNoteAndFlush_calledWith: ParseState.ResetType?
    var createNoteAndFlush_retval: Note?

    override func createNoteAndFlush(reset: ParseState.ResetType) -> Note? {
        createNoteAndFlush_calledWith = reset
        createNoteAndFlush_callCount += 1
        return createNoteAndFlush_retval
    }

    var addNoteOrHighlightText_calledWith: String?
    override func addNoteOrHighlightText(text: String) {
        addNoteOrHighlightText_calledWith = text
    }
}
