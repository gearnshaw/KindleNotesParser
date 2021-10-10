//
//  NoteContextBuilder.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 02/10/2021.
//

import Foundation
@testable import KindleNotesParser

class NoteContextBuilder {
    private var page = 2
    private var location = 2359

    func with(page: Int) -> Self {
        self.page = page
        return self
    }

    func with(location: Int) -> Self {
        self.location = location
        return self
    }

    func build() -> NoteContext {
        return NoteContext(page: page, location: location)
    }
}
