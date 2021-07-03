//
//  File.swift
//  
//
//  Created by Student on 10.06.21.
//

import Foundation

public struct Meter: Identifiable, Equatable {
    public var id: Int64?
    public var meterNumber: Int
    public var accountNumber: Int
    public var title: String
    public var meterType: MeterType
    public var meterReadingEntries: [MeterReadingEntry]
    
    public init (id: Int64?, meterNumber: Int, accountNumber: Int, title: String, meterType: MeterType, meterReadingEntries: [MeterReadingEntry]) {
        self.id = id
        self.meterNumber = meterNumber
        self.accountNumber = accountNumber
        self.title = title
        self.meterReadingEntries = meterReadingEntries
        self.meterType = meterType
    }
    
    public static func == (lhs: Meter, rhs: Meter) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.meterNumber == rhs.meterNumber &&
            lhs.accountNumber == rhs.accountNumber &&
            lhs.title == rhs.title &&
            lhs.meterType == rhs.meterType
    }
}

extension Meter {
    public static var data: [Meter] {
        [
            Meter(id: 1, meterNumber: 123, accountNumber: 123, title: "Example Gas", meterType: MeterType.gas, meterReadingEntries: MeterReadingEntry.data),
            Meter(id: 2, meterNumber: 456, accountNumber: 123, title: "Example Power", meterType: MeterType.power, meterReadingEntries: [])
        ]
    }
}
