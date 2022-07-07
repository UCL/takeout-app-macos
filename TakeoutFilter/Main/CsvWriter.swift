//
//  CsvWriter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 07/07/2022.
//

import Foundation

class CsvWriter {
    
    private let aggregatesHeader: String = "Total_Number_Of_Queries,First_Query_Date"
    private let aggregatesSuffix: String = "-aggregates.csv"
    private let queriesHeader: String = "Date,Query"
    private let queriesSuffix: String = "-queries.csv"
    private let newline: String = "\n"
    private let outputDir: String = "TakeoutFilter"
    
    func writeAggregates(id: Int, totalNumberQueries: Int, firstQueryDate: Date) {
        
    }
    
    func writeQueries(id: Int, queries: [Query]) {
        
    }
}
