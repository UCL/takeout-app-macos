//
//  FilterOutput.swift
//  TakeoutFilter
//
//  Created by David Guzman on 06/07/2022.
//

import Foundation

struct FilterOutput {
    
    var outcome: FilterOutputOutcome = .unknown
    var totalNumberOfQueries: Int = 0
    var firstQueryDate: Date = Date()
    var filteredQueries: [Query] = []
    var filteredQueriesAll: [Query] = []
    var filteredQueriesPhrase: [Query] = []

}

enum FilterOutputOutcome {
    case unknown
    case success
    case failedDataAccess
    case failedData
    case error
}
