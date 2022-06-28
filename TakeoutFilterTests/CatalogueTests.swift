//
//  CatalogueTests.swift
//  TakeoutFilterTests
//
//  Created by David Guzman on 28/06/2022.
//

import XCTest
@testable import TakeoutFilter

class CatalogueTests: XCTestCase {
    
    func testExtractIds() {
        let bundle = Bundle(for: CatalogueTests.self)
        let sampleUrl: URL = URL(fileURLWithPath: "CatalogueSample.csv", relativeTo: bundle.resourceURL)
        let catalogue = Catalogue(catalogue: sampleUrl)
        let result = catalogue.extractIds()
        let expected: [Int] = [1234, 5678]
        XCTAssertEqual(result, expected)
    }
}
