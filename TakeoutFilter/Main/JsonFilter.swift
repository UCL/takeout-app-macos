//
//  JsonFilter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation

class JsonFilter: Filter {
    
    func filterQueries(content: Data, presentationDate: Date, namesToFilter: String) -> FilterOutput {
        do {
            let json = try JSONSerialization.jsonObject(with: content)
            if let queries = json as? [MyActivity] {
                var filterOutput: FilterOutput = FilterOutput()
                filterOutput.firstQueryDate = queries
                    .filter {$0.title.starts(with: "Searched for ")}
                    .map {parseQueryDate($0.time)}
                    .min()!
                filterOutput.totalNumberOfQueries = queries
                    .filter {$0.title.starts(with: "Searched for ")}
                    .count
                filterOutput.filteredQueries = queries
                    .filter {$0.title.starts(with: "Searched for ")}
                    .filter {isDateWithinTwoYearsBeforePresentation(queryDate: $0.time, presentationDate: presentationDate)}
                    .map {removeNameTokens(myActivityItem: $0, namesToFilter: namesToFilter)}
                    .map {myActivityToQuery(myActivityItem: $0)}
                    .filter {binaryContainsTerm(query: $0.query)}
                return filterOutput
            }
        } catch {
            return FilterOutput()
        }
    }

}
