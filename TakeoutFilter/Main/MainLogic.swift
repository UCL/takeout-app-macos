//
//  MainLogic.swift
//  TakeoutFilter
//
//  Created by David Guzman on 27/06/2022.
//

import AppKit
import Foundation
import Zip

struct MainLogic {
    
    private enum ActivityPath: String {
        case json = "/Takeout/My Activity/Search/MyActivity.json"
        case jsonSpace = "/Takeout/My Activity/Search/My Activity.json"
        case html = "/Takeout/My Activity/Search/MyActivity.html"
        case htmlSpace = "/Takeout/My Activity/Search/My Activity.html"
    }
    
    private func getFilePath(id: Int, activityPath: ActivityPath) -> String {
        return "\(id)\(activityPath)"
    }
    
    private let jsonFilter: Filter = JsonFilter()
    private let htmlFilter: Filter = HtmlFilter()
    private let csvWriter: CsvWriter = CsvWriter()
    
    func openFolder() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
    
    func openCsvFile() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.commaSeparatedText]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        
        let response = openPanel.runModal()
        return response == .OK ? openPanel.url : nil
    }
    
    private func doFilterAndWrite(entry: Catalogue.Entry, activityFile: URL, filter: Filter) throws {
        let activityContent: String = try String(contentsOf: activityFile)
        // Run Filter
        let filterOutput: FilterOutput = filter.filterQueries(content: activityContent, presentationDate: entry.getDateOfPresentation(), namesToFilter: entry.getNamesToFilter())
        // Write to CSV
        try csvWriter.writeAggregates(id: entry.getId(), totalNumberQueries: filterOutput.totalNumberOfQueries, firstQueryDate: filterOutput.firstQueryDate)
        try csvWriter.writeQueries(id: entry.getId(), queries: filterOutput.filteredQueries)
    }
    
    func filter(catalogue: URL?, sourceDir: URL?, progress: (Double) -> Void) -> FilterPayback {
        guard let catalogue = catalogue else { return FilterPayback(id: FilterResultType.error, message: "Cannot find catalogue at given URL") }
        guard let sourceDir = sourceDir else { return FilterPayback(id: FilterResultType.error, message: "Cannot find source directory URL") }
        for entry in Catalogue(catalogue: catalogue).entries() {
            let takeoutUrl: URL = sourceDir.appendingPathComponent("\(entry.getId()).zip")
            do {
                let destinationUrl: URL = sourceDir.appendingPathComponent("\(entry.getId())")
                try Zip.unzipFile(takeoutUrl, destination: destinationUrl, overwrite: true, password: nil)
                // Try for JSON file
                if (FileManager.default.fileExists(atPath: getFilePath(id: entry.getId(), activityPath: .json))) {
                    let activityFile: URL = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .json))
                    try doFilterAndWrite(entry: entry, activityFile: activityFile, filter: jsonFilter)
                }
                if (FileManager.default.fileExists(atPath: getFilePath(id: entry.getId(), activityPath: .jsonSpace))) {
                    let activityFile: URL = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .jsonSpace))
                    try doFilterAndWrite(entry: entry, activityFile: activityFile, filter: jsonFilter)
                }
                // Try for HTML file
                if (FileManager.default.fileExists(atPath: getFilePath(id: entry.getId(), activityPath: .html))) {
                    let activityFile: URL = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .html))
                    try doFilterAndWrite(entry: entry, activityFile: activityFile, filter: htmlFilter)
                }
                if (FileManager.default.fileExists(atPath: getFilePath(id: entry.getId(), activityPath: .htmlSpace))) {
                    let activityFile: URL = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .htmlSpace))
                    try doFilterAndWrite(entry: entry, activityFile: activityFile, filter: htmlFilter)
                }
                // Default throw
            } catch {
                return FilterPayback(id: FilterResultType.error, message: "Failed to run filter")
            }
        }
        return FilterPayback(id: FilterResultType.success, message: "Filtering complete")
    }

}
