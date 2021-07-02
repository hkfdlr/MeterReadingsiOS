//
//  File.swift
//  
//
//  Created by Student on 05.06.21.
//

import Foundation

public struct MeterReadingEntry: Identifiable, Codable, Equatable {
    public var id: Int64?
    public var meterNumber: Int
    public var date: Date
    public var readingValue: Double
    
    public init(id: Int64?, meterNumber: Int, date: Date = Date(), readingValue: Double) {
        self.id = id
        self.meterNumber = meterNumber
        self.date = date
        self.readingValue = readingValue
    }
    
    public static func == (lhs: MeterReadingEntry, rhs: MeterReadingEntry) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.meterNumber == rhs.meterNumber &&
            lhs.date == rhs.date &&
            lhs.readingValue == rhs.readingValue
    }
}

extension MeterReadingEntry {
    public static var data: [MeterReadingEntry] {
        [
            MeterReadingEntry(id: nil, meterNumber: 123, date: Date(timeIntervalSince1970: 1623362400), readingValue: 123),
            MeterReadingEntry(id: nil, meterNumber: 123, date: Date(timeIntervalSince1970: 1623189600
            ), readingValue: 111),
            MeterReadingEntry(id: nil, meterNumber: 123, date: Date(timeIntervalSince1970: 1623276000), readingValue: 121)
        ]
    }
}

extension MeterReadingEntry {
    struct Data {
        var id: Int64?
        var meterNumber: Int
        var date: Date = Date()
        var readingValue: Double
    }
    
    var data: Data {
        return Data(id: id, meterNumber: meterNumber, date: date, readingValue: readingValue)
    }
}

typealias MeterReadingEntries = [MeterReadingEntry]
