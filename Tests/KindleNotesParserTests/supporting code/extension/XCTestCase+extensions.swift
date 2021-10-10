//
//  XCTestCase+extensions.swift
//  kindle notes parserTests
//
//  Created by Gabrielle Earnshaw on 03/10/2021.
//

import Foundation
import XCTest

extension XCTestCase {
    func readTestFileContents(fileName: String, fileExtension: String) -> String? {
        let bundle = Bundle.module
        guard let fileUrl = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            return nil
        }

        do {
            return try String.init(contentsOf: fileUrl)
        } catch {
            print("Error reading file \(error)")
            return nil
        }
    }
}
