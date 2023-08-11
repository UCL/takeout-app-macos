//
//  DataAccess.swift
//  TakeoutFilter
//
//  Created by David Guzman on 09/07/2022.
//

import Foundation

class DataAccess {
    
    private let dataSource: DataSource
    
    init?() {
        do {
            dataSource = try DataSource.openDatabase()
        } catch {
            return nil
        }
    }
    
    func hasTerm(_ term: String) throws -> Bool {
        return try dataSource.selectTrueWhereTerm(term: term)
    }
    
    func hasTermStemmed(_ stem: String) throws -> Bool {
        let result = try dataSource.selectTrueWhereStem(stem: stem)
        return result
    }
    
    func containsTermStemmed(_ query: String) throws -> Bool {
        return try dataSource.selectTrueWhereMultiWordStem(phrase: query)
    }

}
