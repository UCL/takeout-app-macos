//
//  PorterStemmer.swift
//  TakeoutFilter
//
//  Created by David Guzman on 14/07/2022.
//

import Foundation

class PorterStemmer {
    
    let stemmer_pointer: OpaquePointer
    
    init() {
        stemmer_pointer = create_stemmer()
        initialiseS()
    }
    
    func runStemmer(_ term: String) -> String {
        guard !term.isEmpty else {
            return ""
        }
        let result: UnsafePointer<CChar> = stemchars(stemmer_pointer, term)!
        return String(cString: result)
    }
    
    deinit {
        free_stemmer(stemmer_pointer)
        freeS()
    }
}
