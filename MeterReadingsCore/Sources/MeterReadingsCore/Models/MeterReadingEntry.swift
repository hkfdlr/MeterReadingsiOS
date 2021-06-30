//
//  File.swift
//  
//
//  Created by Student on 05.06.21.
//

import Foundation

public struct MeterReadingEntry: Identifiable, Codable {
    public let id: UUID
    public let date: Date
    public var readingValue: Int
    public var meterType: MeterType?
    
    public init(id: UUID = UUID(), date: Date = Date(), readingValue: Int, meterType: MeterType?) {
        self.id = id
        self.date = date
        self.readingValue = readingValue
        self.meterType = meterType
    }
}

extension MeterReadingEntry {
    public static var data: [MeterReadingEntry] {
        [
            MeterReadingEntry(id: UUID(), date: Date(timeIntervalSince1970: 1623362400), readingValue: 123, meterType: MeterType.gas),
            MeterReadingEntry(id: UUID(), date: Date(timeIntervalSince1970: 1623276000), readingValue: 121, meterType: MeterType.gas)
        ]
    }
}

extension MeterReadingEntry {
    struct Data {
        var id: UUID = UUID()
        var date: Date = Date()
        var readingValue: Int
        
        var meterType = MeterType.power
    }
    
    var data: Data {
        return Data(id: id, date: date, readingValue: readingValue, meterType: meterType ?? MeterType.power)
    }
    
    mutating func update(from data: Data) {
        readingValue = data.readingValue
        meterType = data.meterType
    }
}

typealias MeterReadingEntries = [MeterReadingEntry]
