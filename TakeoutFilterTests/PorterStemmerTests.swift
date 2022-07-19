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
    
    func testStemVocaculary() {
        let bundle = Bundle(for: CatalogueTests.self)
        let inputUrl = URL(fileURLWithPath: "PorterStemmerInput.txt", relativeTo: bundle.resourceURL)
        let outputUrl = URL(fileURLWithPath: "PorterStemmerOutput.txt", relativeTo: bundle.resourceURL)
        let inputContent = try! String(contentsOf: inputUrl)
        let outputContent = try! String(contentsOf: outputUrl)
        let inputLines = inputContent.components(separatedBy: .newlines)
        let outputLines = outputContent.components(separatedBy: .newlines)
        let porterStemmer = PorterStemmer()
        for index in inputLines.indices {
            let result = porterStemmer.runStemmer(inputLines[index])
            XCTAssertEqual(result, outputLines[index])
        }
    }
}
