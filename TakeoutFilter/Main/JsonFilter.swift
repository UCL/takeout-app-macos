//
//  JsonFilter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation

class JsonFilter: FilterBase, Filter {
    
    func filterQueries(content: String, presentationDate: Date, namesToFilter: String) -> FilterOutput {
        guard let dataAccess = dataAccess else {
            return FilterOutput()
        }
        guard let data = content.data(using: .utf8) else {
            return FilterOutput()
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            if let queries = json as? [MyActivity] {
                var filterOutput: FilterOutput = FilterOutput()
                filterOutput.firstQueryDate = queries
                    .filter {$0.title.starts(with: "Searched for ")}
                    .map {parseQueryDate($0.time)}
                    .min()!
                filterOutput.totalNumberOfQueries = queries
                    .filter {$0.title.starts(with: "Searched for ")}
                    .count
                filterOutput.filteredQueries = try queries
                    .filter {$0.title.starts(with: "Searched for ")}
                    .filter {isDateWithinTwoYearsBeforePresentation(queryDate: $0.time, presentationDate: presentationDate)}
                    .map {removeNameTokens(myActivityItem: $0, namesToFilter: namesToFilter)}
                    .map {myActivityToQuery(myActivityItem: $0)}
                    .filter {try containsTerm(query: $0.query, dataAccess: dataAccess)}
                return filterOutput
            }
        } catch {
            return FilterOutput()
        }
        return FilterOutput()
    }

}
