//
//  Filter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation

class FilterBase {
    
    let dataAccess: DataAccess? = DataAccess()
    
    static let dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()

}

protocol Filter {
    
    func filterQueries(content: String, presentationDate: Date, namesToFilter: String) -> FilterOutput

}

extension Filter {
    
    private func extractWordNGrams(_ query: String) -> [NGram] {
        let words: [String] = query.lowercased()
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .joined(separator: " ")
            .components(separatedBy: .whitespacesAndNewlines)
        if words.count == 1 {
            return [NGram(query: words[0], isMono: true)]
        }
        // contains the n in n-gram where n > 1
        let indices = words.indices
        let nsize = indices.map {$0 + 2}
        
        var queryAsNGrams: [NGram] = words.map { NGram(query: $0, isMono: true) }
        for n in nsize {
            for i in 0...words.count-n {
                let ngram = words[i...i+n].joined(separator: " ")
                queryAsNGrams.append(NGram(query: ngram, isMono: false))
            }
        }
        return queryAsNGrams
    }
    
    func isDateWithinTwoYearsBeforePresentation(queryDate: String, presentationDate: Date) -> Bool {
        let qDate = parseQueryDate(queryDate)
        let twoYearsPresDate = presentationDate.addingTimeInterval(-60 * 60 * 24 * 365 * 2)
        let result = qDate >= twoYearsPresDate && qDate <= presentationDate
        return result
    }
    
    func removeNameTokens(myActivityItem: MyActivity, namesToFilter: String) -> Query {
        let names: [String] = namesToFilter.components(separatedBy: .whitespacesAndNewlines)
        var queryTitle = myActivityItem.title
        for n in names {
            queryTitle = myActivityItem.title.replacingOccurrences(of: n, with: "", options: .caseInsensitive, range: nil)
        }
        let qDate = parseQueryDate(myActivityItem.time)
        return Query(query: queryTitle, date: qDate)
    }
    
    func removeNameTokens(myActivityHtmlItem: MyActivityHtml, namesToFilter: String) -> Query {
        let names: [String] = namesToFilter.components(separatedBy: .whitespacesAndNewlines)
        var queryText = myActivityHtmlItem.query
        for n in names {
            queryText = myActivityHtmlItem.query.replacingOccurrences(of: n, with: "", options: .caseInsensitive, range: nil)
        }
        let qDate = parseQueryDate(myActivityHtmlItem.date)
        return Query(query: queryText, date: qDate)
    }
    
    func containsTerm(query: String, dataAccess: DataAccess) throws -> Bool {
        let result = try extractWordNGrams(query).first {
            $0.isMono ? try dataAccess.hasTerm($0.query) : try dataAccess.hasTermStemmed($0.query)
        }
        return result == nil
    }
    
    func parseQueryDate(_ date: String) -> Date {
        return FilterBase.dateFormatter.date(from: date)!
    }
}
