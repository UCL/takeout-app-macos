//
//  DataSourceTests.swift
//  TakeoutFilterTests
//
//  Created by David Guzman on 19/07/2022.
//

import XCTest
@testable import TakeoutFilter

class DataSourceTests: XCTestCase {
    
    func testOpenDataSource() {
        XCTAssertNoThrow(try DataSource.openDatabase())
    }
}
