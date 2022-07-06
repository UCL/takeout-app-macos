//
//  JsonFilter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation

class JsonFilter: Filter {
    
    func filterQueries(content: Data, presentationDate: Date, namesToFilter: String) -> [Query] {
        do {
            let json = try JSONSerialization.jsonObject(with: content)
            if let queries = json as? [MyActivity] {
                return queries
                    .filter {isDateWithinTwoYearsBeforePresentation(queryDate: $0.time, presentationDate: presentationDate)}
                    .filter {$0.title.starts(with: "Searched for ")}
                    .map {removeNameTokens(myActivityItem: $0, namesToFilter: namesToFilter)}
                    .map {myActivityToQuery(myActivityItem: $0)}
                    .filter {binaryContainsTerm(query: $0.query)}
            }
        } catch {
            return []
        }
    }

}
