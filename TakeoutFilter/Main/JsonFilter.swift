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
            var output = FilterOutput()
            output.outcome = .failedDataAccess
            return output
        }
        guard let data = content.data(using: .utf8) else {
            var output = FilterOutput()
            output.outcome = .failedData
            return output
        }
        do {
            let queries = try JSONDecoder().decode([MyActivity].self, from: data)
            let baseFiltered = queries
                .filter {$0.title.starts(with: "Searched for ") || $0.title.starts(with: "Has buscado ")}
            var filterOutput: FilterOutput = FilterOutput()
            filterOutput.firstQueryDate = baseFiltered
                .map {parseQueryDate($0.time)}
                .min()!
            filterOutput.totalNumberOfQueries = baseFiltered.count
            filterOutput.filteredQueries = try baseFiltered
                .filter {isDateWithinTwoYearsBeforePresentation(queryDate: $0.time, presentationDate: presentationDate)}
                .map {removeNameTokens(myActivityItem: $0, namesToFilter: namesToFilter)}
                .filter {try containsTerm(query: $0.query, stemmer: porterStemmer, dataAccess: dataAccess)}
            filterOutput.outcome = .success
            return filterOutput
        } catch {
            var output = FilterOutput()
            output.outcome = .error
            return output
        }
    }

}
