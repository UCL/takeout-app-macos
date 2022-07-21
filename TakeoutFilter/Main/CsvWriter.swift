//
//  CsvWriter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 07/07/2022.
//

import Foundation

enum CsvError: Error {
    case outputDirNotFound
}

class CsvWriter {
    
    private let aggregatesHeader: String = "Total_Number_Of_Queries,First_Query_Date"
    private let aggregatesSuffix: String = "-aggregates.csv"
    private let queriesHeader: String = "Date,Query"
    private let queriesSuffix: String = "-queries.csv"
    private let newline: String = "\n"
    private let outputDir: String = "TakeoutFilter"
    private var outputUrl: URL?
    private let fileManager: FileManager = FileManager.default
    
    private func getAggregatesFileName(_ id: Int) -> String {
        return "\(id)\(aggregatesSuffix)"
    }
    
    private func getQueriesFileName(_ id: Int) -> String {
        return "\(id)\(queriesSuffix)"
    }
    
    private func writeString(fileName: String, csvContent: String) throws {
        guard let outputDirUrl = outputUrl else {
            throw CsvError.outputDirNotFound
        }
        let outputUrl: URL = outputDirUrl.appendingPathComponent(outputDir)
        if !fileManager.fileExists(atPath: outputDir) {
            try fileManager.createDirectory(at: outputUrl, withIntermediateDirectories: true, attributes: nil)
        }
        let csvUrl: URL = outputUrl.appendingPathComponent(fileName)
        try csvContent.write(to: csvUrl, atomically: true, encoding: .utf8)
    }
    
    func setOutputUrl(_ url: URL) {
        outputUrl = url
    }
    
    func writeAggregates(id: Int, totalNumberQueries: Int, firstQueryDate: Date) throws {
        let csvString = aggregatesHeader.appending(newline)
            .appending("\(totalNumberQueries),\(firstQueryDate)")
            .appending(newline)
        try writeString(fileName: getAggregatesFileName(id), csvContent: csvString)
    }
    
    func writeQueries(id: Int, queries: [Query]) throws {
        var csvString = queriesHeader.appending(newline)
        for q in queries {
            csvString = csvString.appending("\(q.date),\(q.query)")
                .appending(newline)
        }
        try writeString(fileName: getQueriesFileName(id), csvContent: csvString)
    }
}
