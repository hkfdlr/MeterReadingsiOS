//
//  File.swift
//  
//
//  Created by Student on 10.06.21.
//

import Foundation

public struct Account: Identifiable {
    public let id: UUID
    public let accountNumber: Int
    public var title: String
    public var meters: [Meter]
    
    public init(id: UUID = UUID(), accountNumber: Int, title: String, meters: [Meter] = []) {
        self.id = id
        self.accountNumber = accountNumber
        self.title = title
        self.meters = meters
    }
}

public extension Account {
    static var data: [Account] {
        [
            Account(accountNumber: 123, title: "Example Account", meters: Meter.data)
        ]
    }
}

public extension Account {
    struct Data {
        let accountNumber: Int = 0
        var title: String = ""
        var meters: [Meter] = []
        
        public init () {}
    }
    
    mutating func update(from data: Data) {
        title = data.title
    }
    
}
