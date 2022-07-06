//
//  Filter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation

protocol Filter {
    
    func filterQueries(content: Data, presentationDate: Date, namesToFilter: String) -> [Query]

}

extension Filter {
    
    func isDateWithinTwoYearsBeforePresentation(queryDate: String, presentationDate: Date) -> Bool {
        
    }
    
    func removeNameTokens(myActivityItem: MyActivity, namesToFilter: String) -> MyActivity {
        
    }
    
    func myActivityToQuery(myActivityItem: MyActivity) -> Query {
        
    }
    
    func binaryContainsTerm(query: String) -> Bool {
        
    }
}
