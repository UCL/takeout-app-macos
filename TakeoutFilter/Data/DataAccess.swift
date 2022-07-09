//
//  DataAccess.swift
//  TakeoutFilter
//
//  Created by David Guzman on 09/07/2022.
//

import Foundation

class DataAccess {
    
    private let dataSource: DataSource
    
    init() throws {
        dataSource = try DataSource.openDatabase()
    }
    
    func hasTerm(_ term: String) throws -> Bool {
        return try dataSource.selectTrueWhereTerm(term: term)
    }

}
