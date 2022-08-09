//
//  HtmlFilter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation
import SwiftSoup

class HtmlFilter: FilterBase, Filter {
    
    private var htmlDateFormatter: DateFormatter = UsDateFormatter().obtainFormatter()
    private var bstDateFormatter: DateFormatter = BstDateFormatter().obtainFormatter()
    
    private func selectChildren(_ element: Element) throws -> MyActivityHtml {
        let parent = element.parent()!
        let childNodes = parent.children()
        let textNodes = parent.textNodes()
        let qType = textNodes[0].text()
        let qQuery = try childNodes.get(0).text()
        let qDate = parseHtmlDate(textNodes[1].text())
        return MyActivityHtml(type: qType, query: qQuery, date: qDate)
    }
    
    private func isValidElement(_ element: Element) -> Bool {
        let parent = element.parent()
        guard let p = parent else {
            return false
        }
        guard p.children().count >= 2 else {
            return false
        }
        guard p.textNodes().count == 2 else {
            return false
        }
        return true
    }
    
    private func parseHtmlDate(_ date: String) -> Date {
        let htmlDate: Date? = htmlDateFormatter.date(from: date)
        if let htmlDate = htmlDate {
            return htmlDate
        }
        let bstDate: Date? = bstDateFormatter.date(from: date)
        if let bstDate = bstDate {
            return bstDate
        }
        return Date(timeIntervalSince1970: 0)
    }
    
    private func isDateWithinTwoYearsBeforePresentation(queryDate: Date, presentationDate: Date) -> Bool {
        let twoYearsPresDate = presentationDate.addingTimeInterval(-60 * 60 * 24 * 365 * 2)
        let result = queryDate >= twoYearsPresDate && queryDate <= presentationDate
        return result
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
                .filter { $0.type.contains("Searched for") }
            var filterOutput: FilterOutput = FilterOutput()
            if baseFiltered.isEmpty {
                return filterOutput
            }
            filterOutput.firstQueryDate = baseFiltered
                .map {$0.date}
                .min()!
            filterOutput.totalNumberOfQueries = baseFiltered.count
            filterOutput.filteredQueries = try baseFiltered
                .filter {isDateWithinTwoYearsBeforePresentation(queryDate: $0.date, presentationDate: presentationDate)}
                .map {removeNameTokens(myActivityHtmlItem: $0, namesToFilter: namesToFilter)}
                .filter {try containsTerm(query: $0.query, stemmer: porterStemmer, dataAccess: dataAccess)}
            filterOutput.outcome = .success
            return filterOutput
        } catch {
            return FilterOutput()
        }
    }

}
