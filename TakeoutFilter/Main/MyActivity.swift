//
//  MyActivity.swift
//  TakeoutFilter
//
//  Created by David Guzman on 06/07/2022.
//

import Foundation

struct MyActivity: Decodable {
    
    let header: String
    let title: String
    let time: String

}

struct MyActivityHtml {
    
    let type: String
    let query: String
    let date: Date
    
}
