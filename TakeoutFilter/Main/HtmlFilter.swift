//
//  HtmlFilter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation
import SwiftSoup

class HtmlFilter: FilterBase, Filter {
    
    private func selectChildren(_ element: Element) throws -> MyActivityHtml {
        let parent = element.parent()
        let qType = try parent?.children().get(0).text()
        let qQuery = try parent?.children().get(1).text()
        let qDate = try parent?.children().get(3).text()
        return MyActivityHtml(type: qType!, query: qQuery!, date: qDate!)
    }
    
    private func isValidElement(_ element: Element) -> Bool {
        let parent = element.parent()
        return parent?.childNode(0) != nil && parent?.childNode(1) != nil && parent?.childNode(3) != nil
    }
    
    func filterQueries(content: String, presentationDate: Date, namesToFilter: String) -> FilterOutput {
        guard let dataAccess = dataAccess else {
            return FilterOutput()
        }
        do {
            let html = try SwiftSoup.parse(content)
            let searches = try html.select("div.content-cell.mdl-cell.mdl-cell--6-col.mdl-typography--body-1 a")
            let baseFiltered = try searches
                .filter { isValidElement($0) }
                .map { try selectChildren($0) }
                .filter { $0.type.starts(with: "S") }
            var filterOutput: FilterOutput = FilterOutput()
            filterOutput.firstQueryDate = baseFiltered
                .map {parseQueryDate($0.date)}
                .min()!
            filterOutput.totalNumberOfQueries = baseFiltered.count
            filterOutput.filteredQueries = try baseFiltered
                .filter {isDateWithinTwoYearsBeforePresentation(queryDate: $0.date, presentationDate: presentationDate)}
                .map {removeNameTokens(myActivityHtmlItem: $0, namesToFilter: namesToFilter)}
                .filter {try containsTerm(query: $0.query, stemmer: porterStemmer, dataAccess: dataAccess)}
            return filterOutput
        } catch {
            return FilterOutput()
        }
    }

}
