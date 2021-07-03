//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class GetReadingAdapter: ReadingGetter {
    public init () {}
    
    public func getReadings(meterNumber: Int, completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws {
        try AppDatabase.shared.getAllReadings(meterNumber: meterNumber) {
            completion($0)
        }
    }
}
