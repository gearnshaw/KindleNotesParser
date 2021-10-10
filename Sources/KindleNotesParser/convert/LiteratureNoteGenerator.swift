//
//  LiteratureNoteGenerator.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 04/10/2021.
//

import Foundation

protocol NoteGenerator {
    func generateFrom(note: Note, withValues globalValueProviders: [TemplateValueProvider]) -> String?
}

struct LiteratureNoteGenerator {
    let template: String
    let globalValueProviders: [TemplateValueProvider]

    func generateFrom(note: Note) -> String? {
        let templateReplacer = SimpleTemplateReplacer()
        let valueProviders = [note] + globalValueProviders
        return templateReplacer.replace(template: template, with: valueProviders)
    }
}
