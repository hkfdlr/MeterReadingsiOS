//
//  File.swift
//  
//
//  Created by Student on 01.07.21.
//

// made in accordance to GRDB.swift#fetchableRecord, see https://github.com/groue/GRDB.swift#fetchablerecord-protocol

import Foundation
import MeterReadingsCore
import GRDB

extension Account: TableRecord, FetchableRecord, MutablePersistableRecord {
    
    static let meters = hasMany(Meter.self, using: Meter.assocAccount)
    
    public func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["title"] = title
        container["accountNumber"] = accountNumber
    }
    
    public init(row: Row) {
        self.init(id: nil, accountNumber: 0, title: "")
        id = row["id"]
        title = row["title"]
        accountNumber = row["accountNumber"]
    }
    

    
    
}
