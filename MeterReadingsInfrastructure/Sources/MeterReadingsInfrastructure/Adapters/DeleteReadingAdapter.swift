//
//  File.swift
//  
//
//  Created by Student on 04.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class DeleteReadingAdapter: ReadingDeleter {
    public init () {}
    
    public func deleteReading(reading: MeterReadingEntry, completion: @escaping (Result<String,Error>) -> Void) throws {
        try AppDatabase.shared.deleteReading(reading: reading, completion: {
            completion($0)
        })
    }
}
