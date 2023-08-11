//
//  CsvWriter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 07/07/2022.
//

import Foundation

enum CsvError: Error {
    case outputBaseDirNotFound
    case outputDirNotFound
    case outputFileNotFound
}

class CsvWriter {
    
    private let aggregatesHeader: String = "Total_Number_Of_Queries,First_Query_Date"
    private let aggregatesSuffix: String = "-aggregates.csv"
    private let queriesHeader: String = "Date,Query"
    private let queriesSuffix: String = "-queries.csv"
    private let queriesPhraseSuffix: String = "-queries-phrase.csv"
    private let queriesAllSuffix: String = "-queries-all.csv"
    private let newline: String = "\n"
    private let outputDir: String = "TakeoutFilter"
    private var outputDirUrl: URL?
    private let fileManager: FileManager = FileManager.default
    
    private func getAggregatesFileName(_ id: Int) -> String {
        return "\(id)\(aggregatesSuffix)"
    }
    
    private func getQueriesFileName(_ id: Int) -> String {
        return "\(id)\(queriesSuffix)"
    }
    
    private func getQueriesPhraseFileName(_ id: Int) -> String {
        return "\(id)\(queriesPhraseSuffix)"
    }
    
    private func getQueriesAllFileName(_ id: Int) -> String {
        return "\(id)\(queriesAllSuffix)"
    }

    private func writeString(fileName: String, csvContent: String) throws {
        guard let output = outputDirUrl else {
            throw CsvError.outputDirNotFound
        }
        let csvUrl: URL = output.appendingPathComponent(fileName)
        try csvContent.write(to: csvUrl, atomically: true, encoding: .utf8)
    }
    
    func configureOutput(_ url: URL) throws {
        outputDirUrl = url.appendingPathComponent(outputDir)
        guard let output = outputDirUrl else {
            throw CsvError.outputBaseDirNotFound
        }
        if fileManager.fileExists(atPath: output.path) {
            try fileManager.removeItem(at: output)
        }
        try fileManager.createDirectory(at: output, withIntermediateDirectories: true, attributes: nil)
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
    
    func writeQueriesPhrase(id: Int, queries: [Query]) throws {
        var csvString = queriesHeader.appending(newline)
        for q in queries {
            csvString = csvString.appending("\(q.date),\(q.query)")
                .appending(newline)
        }
        try writeString(fileName: getQueriesPhraseFileName(id), csvContent: csvString)
    }
    
    func writeQueriesAll(id: Int, queries: [Query]) throws {
        var csvString = queriesHeader.appending(newline)
        for q in queries {
            csvString = csvString.appending("\(q.date),\(q.query)")
                .appending(newline)
        }
        try writeString(fileName: getQueriesAllFileName(id), csvContent: csvString)
    }
}
