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
        return "\(id)\(activityPath.rawValue)"
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
        try csvWriter.writeQueries(id: entry.getId(), queries: filterOutput.filteredQueries)
        try csvWriter.writeAggregates(id: entry.getId(), totalNumberQueries: filterOutput.totalNumberOfQueries, firstQueryDate: filterOutput.firstQueryDate)
    }
    
    func filter(catalogue: URL?, sourceDir: URL?, outputDir: URL?, progress: (Double) -> Void) -> FilterPayback {
        guard let catalogueUrl = catalogue else { return FilterPayback(id: FilterResultType.error, message: "Cannot find catalogue at given URL") }
        guard let sourceDir = sourceDir else { return FilterPayback(id: FilterResultType.error, message: "Cannot find source directory URL") }
        guard let outputDir = outputDir else {
            return FilterPayback(id: FilterResultType.error, message: "Cannot find output directory URL")
        }
        
        do {
            try csvWriter.configureOutput(outputDir)
        } catch {
            return FilterPayback(id: FilterResultType.error, message: "Cannot configure output directory")
        }
        let c = Catalogue(catalogue: catalogueUrl)
        let catalogueEntries = c.entries()
        let catalogueSize = catalogueEntries.count
        for (index, entry) in catalogueEntries.enumerated() {
            let takeoutUrl: URL = sourceDir.appendingPathComponent("\(entry.getId()).zip")
            do {
                let destinationUrl: URL = sourceDir.appendingPathComponent("\(entry.getId())")
                if !FileManager.default.fileExists(atPath: destinationUrl.path) {
                    try FileManager.default.createDirectory(at: destinationUrl, withIntermediateDirectories: false)
                }
                try Zip.unzipFile(takeoutUrl, destination: destinationUrl, overwrite: true, password: nil)
                // Try for JSON file
                let jsonUrl = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .json))
                if (FileManager.default.fileExists(atPath: jsonUrl.path)) {
                    try doFilterAndWrite(entry: entry, activityFile: jsonUrl, filter: jsonFilter)
                }
                let jsonSpaceUrl = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .jsonSpace))
                if (FileManager.default.fileExists(atPath: jsonSpaceUrl.path)) {
                    try doFilterAndWrite(entry: entry, activityFile: jsonSpaceUrl, filter: jsonFilter)
                }
                // Try for HTML file
                let htmlUrl = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .html))
                if (FileManager.default.fileExists(atPath: htmlUrl.path)) {
                    try doFilterAndWrite(entry: entry, activityFile: htmlUrl, filter: htmlFilter)
                }
                let htmlSpaceUrl = sourceDir.appendingPathComponent(getFilePath(id: entry.getId(), activityPath: .htmlSpace))
                if (FileManager.default.fileExists(atPath: htmlSpaceUrl.path)) {
                    try doFilterAndWrite(entry: entry, activityFile: htmlSpaceUrl, filter: htmlFilter)
                }
                // Default throw
            } catch {
                return FilterPayback(id: FilterResultType.error, message: "Failed to run filter \(error)")
            }
            let prog = Double(index + 1) / Double(catalogueSize) * 100
            progress(prog)
        }
        return FilterPayback(id: FilterResultType.success, message: "Filtering complete")
    }

}
