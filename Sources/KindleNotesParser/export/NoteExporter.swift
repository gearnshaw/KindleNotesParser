//
//  NoteExporter.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 10/10/2021.
//

import Foundation

protocol NoteExporter {
    func export(text: String) -> Bool
}
