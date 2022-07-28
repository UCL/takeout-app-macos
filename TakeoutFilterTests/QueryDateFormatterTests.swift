//
//  QueryDateFormatterTests.swift
//  TakeoutFilterTests
//
//  Created by David Guzman on 20/07/2022.
//

import XCTest
@testable import TakeoutFilter

class QueryDateFormatterTests: XCTestCase {
    
    func testFormatHtmlDate() {
        let formatter: DateFormatter = UsDateFormatter().obtainFormatter()
        let input = "Feb 25, 2021, 4:27:07 PM BST"
        let actual = formatter.date(from: input)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm:ss a zzz"
        let expected = dateFormatter.date(from: input)
        XCTAssertEqual(actual, expected)
    }
}
