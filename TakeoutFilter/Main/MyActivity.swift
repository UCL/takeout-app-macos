//
//  MyActivity.swift
//  TakeoutFilter
//
//  Created by David Guzman on 06/07/2022.
//

import Foundation

struct MyActivity {
    
    let header: String
    var title: String
    let titleUrl: String
    let time: String
    let products: [String]

    func setTitle(_ title: String) {
        self.title = title
    }
}
