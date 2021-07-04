//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class SaveReadingAdapter: ReadingSaver {
    public init () {}
    
    public func saveReading(reading: inout MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.shared.saveMeterReading(&reading) {
            completion($0)
        }
    }
}
