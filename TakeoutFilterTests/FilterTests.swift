//
//  FilterTests.swift
//  TakeoutFilterTests
//
//  Created by David Guzman on 19/07/2022.
//

import XCTest
@testable import TakeoutFilter

import SwiftSoup

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
        XCTAssertEqual(result.filteredQueries.count, 4)
    }
    
    func testHtmlFilter() {
        let bundle = Bundle(for: CatalogueTests.self)
        let htmlUrl = URL(fileURLWithPath: "MyActivity.html", relativeTo: bundle.resourceURL)
        let htmlContent = try! String(contentsOf: htmlUrl)
        let instance: Filter = HtmlFilter()
        let result = instance.filterQueries(content: htmlContent, presentationDate: Date(), namesToFilter: "Forename Surname")
        XCTAssertEqual(result.outcome, .success)
        XCTAssertEqual(result.totalNumberOfQueries, 3)
        let expectedDate = UsDateFormatter().obtainFormatter().date(from: "Feb 15, 2021, 4:45:11 PM BST")
        XCTAssertEqual(result.firstQueryDate, expectedDate)
        XCTAssertEqual(result.filteredQueries.count, 3)
    }
    
    func testHtmlErrorFilter() {
        let bundle = Bundle(for: CatalogueTests.self)
        let htmlUrl = URL(fileURLWithPath: "MyActivityError.html", relativeTo: bundle.resourceURL)
        let htmlContent = try! String(contentsOf: htmlUrl)
        let instance: Filter = HtmlFilter()
        let result = instance.filterQueries(content: htmlContent, presentationDate: Date(), namesToFilter: "Forename Surname")
        XCTAssertEqual(result.outcome, .success)
        XCTAssertEqual(result.totalNumberOfQueries, 3)
        let expectedDate = UsDateFormatter().obtainFormatter().date(from: "Feb 15, 2021, 4:45:11 PM BST")
        XCTAssertEqual(result.firstQueryDate, expectedDate)
        XCTAssertEqual(result.filteredQueries.count, 2)
    }

}
