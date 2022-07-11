//
//  HtmlFilter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation
import SwiftSoup

class HtmlFilter: FilterBase, Filter {
    
    func filterQueries(content: String, presentationDate: Date, namesToFilter: String) -> FilterOutput {
        guard let dataAccess = dataAccess else {
            return FilterOutput()
        }
        return FilterOutput()
    }

}
