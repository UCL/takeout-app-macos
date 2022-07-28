//
//  Catalogue.swift
//  TakeoutFilter
//
//  Created by David Guzman on 27/06/2022.
//

import Foundation

struct Catalogue {
    
    private var catalogueUrl: URL
    
    private var iso8601DateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    
    init(catalogue: URL) {
        self.catalogueUrl = catalogue
        // Configure formatter to not to expect time part. Expected string in YYYY-MM-DD format.
        self.iso8601DateFormatter.formatOptions = .withFullDate
    }
    
    func entries() -> [Entry] {
        var entries: [Entry] = []
        do {
            let stringContent = try String(contentsOfFile: catalogueUrl.path)
            let stringLines: [String] = stringContent.components(separatedBy: "\n").filter(){$0 != ""}
            for index in 1 ..< stringLines.count {
                let line: [String] = stringLines[index].components(separatedBy: ",")
                let intId = Int(line[0]) ?? 0
                if (intId != 0) {
                    let datePresentation: Date? = iso8601DateFormatter.date(from: line[1])
                    guard let datePresentation = datePresentation else {
                        throw DateParsingError("Cannot parse date \(line[1])")
                    }
                    let e: Entry = Entry(id: intId, dateOfPresentation: datePresentation, namesToFilter: line[2])
                    entries.append(e)
                }
            }
            return entries
        } catch {
            return entries
        }
    }
    
    func extractIds() -> [Int] {
        var ids: [Int] = []
        do {
            let stringContent = try String(contentsOfFile: catalogueUrl.path)
            let stringLines: [String] = stringContent.components(separatedBy: "\n").filter(){$0 != ""}
            for index in 1 ..< stringLines.count {
                let line: [String] = stringLines[index].components(separatedBy: ",")
                let intId = Int(line[0]) ?? 0
                if (intId != 0) {
                    ids.append(intId)
                }
            }
            return ids
        } catch {
            return ids
        }
    }
    
    struct Entry: Equatable {
        
        private var id: Int
        
        private var dateOfPresentation: Date
        
        private var namesToFilter: String
        
        init(id: Int, dateOfPresentation: Date, namesToFilter: String) {
            self.id = id
            self.dateOfPresentation = dateOfPresentation
            self.namesToFilter = namesToFilter
        }
        
        func getId() -> Int {
            return id
        }
        
        func getNamesToFilter() -> String {
            return namesToFilter
        }
        
        func getDateOfPresentation() -> Date {
            return dateOfPresentation
        }
    }
    
    struct DateParsingError: Error {
        
        private let message: String
        
        init(_ message: String) {
            self.message = message
        }
    }
}
