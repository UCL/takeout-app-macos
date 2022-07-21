//
//  ISODateFormatter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 19/07/2022.
//

import Foundation

class ISODateFormatter: ISO8601DateFormatter {
    
    func obtainFormatter() -> ISO8601DateFormatter {
        formatOptions = [.withFullDate]
        return self
    }
}

class UsDateFormatter: DateFormatter {
    
    func obtainFormatter() -> DateFormatter {
        dateFormat = "MMM d, yyyy, h:mm:ss a zzz"
        return self
    }
}
