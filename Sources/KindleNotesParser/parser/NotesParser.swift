//
//  NotesParser.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 30/09/2021.
//

import Foundation
import SwiftSoup

struct NotesParser {
    private let parseManager: ParseManager

    init(parseManager: ParseManager) {
        self.parseManager = parseManager
    }

    func parseFile() {
        let htmlUrl = URL(fileURLWithPath: "/Users/gabriellelittler/Desktop/Accelerate - Notebook.html");
        parseFile(fileUrl: htmlUrl)
    }

    func parseFile(fileUrl: URL) {
        do {
            let html = try String.init(contentsOf: fileUrl)
            parseNotes(html: html)
        } catch {
            print("Error reading file \(error)")
        }
    }

    func parseNotes(html: String) {
        do {
            let doc = try SwiftSoup.parse(html)
            let body = doc.body()
            guard let body = body else { return }

            let divs = try body.select("div")


            divs.forEach { div in
                do {
                    guard let className = try? div.className() else { return }
                    guard let text = try? div.text() else { return }

                    switch className {
                    case "sectionHeading":
                        parseManager.handleSectionHeading(sectionHeading: text)
                    case "noteHeading":
                        parseManager.handleNoteHeading(noteHeading: text)
                    case "noteText":
                        parseManager.handleNoteText(noteText: text)
                    default:
                        print("Not handling content of \(className)")
                    }

                }
            }
            parseManager.finish()
        } catch {
            print("Error reading file \(error)")
        }
    }
}
