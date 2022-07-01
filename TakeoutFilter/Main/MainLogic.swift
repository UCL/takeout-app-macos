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
    
    private let jsonFilter: Filter = JsonFilter()
    private let htmlFilter: Filter = HtmlFilter()
    
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
    
    func filter(catalogue: URL?, sourceDir: URL?) {
        guard let catalogue = catalogue else { return }
        guard let sourceDir = sourceDir else { return }
        for entry in Catalogue(catalogue: catalogue).entries() {
            let takeoutUrl: URL = sourceDir.appendingPathComponent("\(entry.getId()).zip")
            do {
                let destinationUrl: URL = sourceDir.appendingPathComponent("\(entry.getId())")
                try Zip.unzipFile(takeoutUrl, destination: destinationUrl, overwrite: true, password: nil)
                // Try for JSON file
                if (FileManager.default.fileExists(atPath: "\(entry.getId())/Takeout/My Activity/Search/MyActivity.json")) {
                    // Run JsonFilter
                }
                // Try for HTML file
                if (FileManager.default.fileExists(atPath: "\(entry.getId())/Takeout/My Activity/Search/MyActivity.html")) {
                    // Run HTML file
                }
                // Try for HTML file
                // Default throw
            } catch {
                return
            }
        }
    }

}
