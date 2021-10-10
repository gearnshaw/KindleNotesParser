//
//  BearNoteExporter.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 10/10/2021.
//

#if os(macOS)
import Foundation
import AppKit

struct BearNoteExporter: NoteExporter {
    let urlOpener: URLOpening

    func export(text: String) -> Bool {
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return false
        }

        guard let url = URL(string: "bear://x-callback-url/create?text=\(encoded)") else {
            return false
        }

        return urlOpener.open(url)
    }
}
#endif
