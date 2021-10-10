//
//  GlobalValueProviderBuilder.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 09/10/2021.
//

import Foundation
@testable import KindleNotesParser

class GlobalValueProviderBuilder {
    private var date: Date = Date()
    private var bookLink: String = "[[Book: My book]]"

    func with(date: Date) -> Self {
        self.date = date
        return self
    }

    func with(bookLink: String) -> Self {
        self.bookLink = bookLink
        return self
    }

    func build() -> GlobalValueProvider {
        return GlobalValueProvider(date: date, bookLink: bookLink)
    }
}
