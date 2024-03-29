//
//  File.swift
//  
//
//  Created by Student on 02.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

extension Meter: TableRecord, FetchableRecord, MutablePersistableRecord {

    static let assocAccount = ForeignKey(["accountNumber"])
    static let account = belongsTo(Account.self, using: assocAccount)
    
    static let meterReadingEntries = hasMany(MeterReadingEntry.self, using: MeterReadingEntry.assocMeter)
        
    var meterTypeAsString: String {
        return meterType.rawValue.description
    }
    
    public init(row: Row) {
        self.init(id: nil, meterNumber: 0, accountNumber: 0, title: "", meterType: MeterType.power, meterReadingEntries: [])
        id = row["id"]
        title = row["title"]
        accountNumber = row["accountNumber"]
        meterNumber = row["meterNumber"]
        meterType = MeterType(rawValue: row["meterType"]) ?? meterType
        
    }
    
    public func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["meterNumber"] = meterNumber
        container["accountNumber"] = accountNumber
        container["title"] = title
        container["meterType"] = meterType.rawValue.description
    }
}
