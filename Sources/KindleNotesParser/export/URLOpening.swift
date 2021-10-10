//
//  URLOpening.swift
//  kindle notes parser
//
//  Created by Gabrielle Earnshaw on 10/10/2021.
//

import Foundation

protocol URLOpening {
    func open(_ url: URL) -> Bool
}

#if os(macOS)
import AppKit
extension NSWorkspace: URLOpening {}
#endif
