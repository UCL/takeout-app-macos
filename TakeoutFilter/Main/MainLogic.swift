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
        let catalogueAccess = Catalogue(catalogue: catalogue)
        for entry in catalogueAccess.entries() {
            let takeoutUrl: URL = sourceDir.appendingPathComponent("\(entry.getId()).zip")
        }
    }

}
