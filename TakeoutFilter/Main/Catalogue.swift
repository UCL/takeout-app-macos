//
//  Catalogue.swift
//  TakeoutFilter
//
//  Created by David Guzman on 27/06/2022.
//

import Foundation

struct Catalogue {
    
    private var catalogueUrl: URL
    
    init(catalogue: URL) {
        catalogueUrl = catalogue
    }
    
    func extractIds() -> [Int] {
        var ids: [Int] = []
        do {
            let stringContent = try String(contentsOfFile: catalogueUrl.path)
            let stringLines: [String] = stringContent.components(separatedBy: "\n")
            for index in 1...stringLines.capacity - 1 {
                let intId = Int(stringLines[index].components(separatedBy: ",")[0]) ?? 0
                if (intId != 0) {
                    ids.append(intId)
                }
            }
            return ids
        } catch {
            return ids
        }
    }
}
