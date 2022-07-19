//
//  FilterTests.swift
//  TakeoutFilterTests
//
//  Created by David Guzman on 19/07/2022.
//

import XCTest
@testable import TakeoutFilter

class FilterTests: XCTestCase {
    
    func testJsonFilter() {
        let bundle = Bundle(for: CatalogueTests.self)
        let jsonUrl = URL(fileURLWithPath: "MyActivity.json", relativeTo: bundle.resourceURL)
        let jsonContent = try! String(contentsOf: jsonUrl)
        let instance: Filter = JsonFilter()
        let result = instance.filterQueries(content: jsonContent, presentationDate: Date(), namesToFilter: "Forename Surname")
        XCTAssertEqual(result.outcome, .success)
        XCTAssertEqual(result.totalNumberOfQueries, 4)
        let expectedDate = ISODateFormatter().obtainFormatter().date(from: "2021-02-15")
        XCTAssertEqual(result.firstQueryDate, expectedDate)
        XCTAssertEqual(result.filteredQueries.count, 3)
    }
}
