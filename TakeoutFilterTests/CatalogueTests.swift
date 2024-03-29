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
    
    func testEntries() {
        let bundle = Bundle(for: CatalogueTests.self)
        let sampleUrl: URL = URL(fileURLWithPath: "CatalogueSample.csv", relativeTo: bundle.resourceURL)
        let catalogue = Catalogue(catalogue: sampleUrl)
        let result = catalogue.entries()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        let aDate: Date? = formatter.date(from: "2022-06-28")
        guard let aDate = aDate else {
           return
        }
        let e1: Catalogue.Entry = Catalogue.Entry(id: 1234, dateOfPresentation: aDate, namesToFilter: "Forename Surname")
        let e2: Catalogue.Entry = Catalogue.Entry(id: 5678, dateOfPresentation: aDate, namesToFilter: "Forename Surname")
        let expected: [Catalogue.Entry] = [e1, e2]
        XCTAssertEqual(result, expected)
    }
}
