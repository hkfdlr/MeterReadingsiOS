//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

extension MeterReadingEntry: TableRecord, FetchableRecord, MutablePersistableRecord {
    
    static let meter = belongsTo(Meter.self)
    
    public init(row: Row) {
        self.init(id: nil, meterNumber: 0, date: Date(), readingValue: 0)
        id = row["id"]
        meterNumber = row["meterNumber"]
        date = row["date"]
        readingValue = row["readingValue"]
    }
    
    public func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["meterNumber"] = meterNumber
        container["date"] = date
        container["readingValue"] = readingValue
    }
}
