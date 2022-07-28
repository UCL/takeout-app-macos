//
//  NGram.swift
//  TakeoutFilter
//
//  Created by David Guzman on 10/07/2022.
//

import Foundation

struct NGram {
    
    let query: String
    let isMono: Bool
    
    init(query: String, isMono: Bool) {
        self.query = query
        self.isMono = isMono
    }

}
