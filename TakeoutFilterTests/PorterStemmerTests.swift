//
//  PorterStemmerTests.swift
//  TakeoutFilterTests
//
//  Created by David Guzman on 18/07/2022.
//

import XCTest

@testable import TakeoutFilter

class PorterStemmerTests: XCTestCase {
    
    func testStemString() {
        let porterStemmer = PorterStemmer()
        let actual = porterStemmer.runStemmer("bleeding")
        let expected = "bleed"
        XCTAssertEqual(actual, expected)
    }
}
