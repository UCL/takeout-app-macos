//
//  DataSource.swift
//  TakeoutFilter
//
//  Created by David Guzman on 09/07/2022.
//

import Foundation
import SQLite3

class DataSource {
    
    private static let databaseFile: String = "TakeoutFilter"
    
    private let databasePointer: OpaquePointer?
    
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(databasePointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message returned by data source"
        }
    }
    
    private init(_ dbPointer: OpaquePointer?) {
        self.databasePointer = dbPointer
    }
    
    static func openDatabase() throws -> DataSource {
        var db: OpaquePointer?
        guard let dbFileUrl = Bundle.main.url(
            forResource: databaseFile,
            withExtension: "sqlite"
        ) else {
            throw DataSourceError.Open(message: "Cannot find database file")
        }
        if (sqlite3_open(dbFileUrl.path, &db) == SQLITE_OK) {
            return DataSource(db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw DataSourceError.Open(message: message)
            } else {
                throw DataSourceError.Open(message: "Failed without an error message")
            }
        }
    }
    
    deinit {
        sqlite3_close(databasePointer)
    }
}

extension DataSource {
    
    private func prepareStatement(statement: String) throws -> OpaquePointer? {
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(databasePointer, statement, -1, &stmt, nil) == SQLITE_OK else {
            throw DataSourceError.Prepare(message: errorMessage)
        }
        return stmt
    }
    
    func selectTrueWhereTerm(term: String) throws -> Bool {
        let querySql = "SELECT EXISTS (SELECT 1 FROM MEDICAL_TERMS WHERE TERM = ?);"
        guard let queryStmt = try prepareStatement(statement: querySql) else {
            return false
        }
        defer {
            sqlite3_finalize(queryStmt)
        }
        guard sqlite3_bind_text(queryStmt, 1, term, -1, nil) == SQLITE_OK else {
            throw DataSourceError.Bind(message: "Failed to bind String to statement")
        }
        guard sqlite3_step(queryStmt) == SQLITE_ROW else {
            throw DataSourceError.Step(message: "Failed to run query and return row")
        }
        return sqlite3_column_int(queryStmt, 0) == 1
    }
    
    func selectTrueWhereStem(stem: String) throws -> Bool {
        let querySql = "SELECT EXISTS (SELECT 1 FROM MEDICAL_TERM_STEMS WHERE STEM = ?);"
        guard let queryStmt = try prepareStatement(statement: querySql) else {
            return false
        }
        defer {
            sqlite3_finalize(queryStmt)
        }
        guard sqlite3_bind_text(queryStmt, 1, stem, -1, nil) == SQLITE_OK else {
            throw DataSourceError.Bind(message: "Failed to bind String to statement")
        }
        guard sqlite3_step(queryStmt) == SQLITE_ROW else {
            throw DataSourceError.Step(message: "Failed to run query and return row")
        }
        return sqlite3_column_int(queryStmt, 0) == 1
    }

}

enum DataSourceError: Error {
    case Open(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}
