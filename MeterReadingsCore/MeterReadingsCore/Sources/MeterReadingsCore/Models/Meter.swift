//
//  File.swift
//  
//
//  Created by Student on 10.06.21.
//

import Foundation

public struct Meter: Identifiable {
    public var id: UUID
    public let meterNumber: Int
    public var title: String
    public var meterType: MeterType
    public var meterReadingEntries: [MeterReadingEntry]
    
    public init (id: UUID = UUID(), meterNumber: Int, title: String, meterType: MeterType, meterReadingEntries: [MeterReadingEntry]) {
        self.id = id
        self.meterNumber = meterNumber
        self.title = title
        self.meterReadingEntries = meterReadingEntries
        self.meterType = meterType
    }
}

extension Meter {
    public static var data: [Meter] {
        [
            Meter(meterNumber: 123, title: "Example Gas", meterType: MeterType.gas, meterReadingEntries: MeterReadingEntry.data),
            Meter(meterNumber: 456, title: "Example Power", meterType: MeterType.power, meterReadingEntries: [])
        ]
    }
}
