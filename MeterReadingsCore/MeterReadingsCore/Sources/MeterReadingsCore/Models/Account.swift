//
//  File.swift
//  
//
//  Created by Student on 10.06.21.
//

import Foundation

public struct Account: Identifiable, Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        return
            lhs.accountNumber == rhs.accountNumber &&
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.meters == rhs.meters
    }
    
    public var id: Int64?
    public var accountNumber: Int
    public var title: String
    public var meters: [Meter]
    
    public init(id: Int64?, accountNumber: Int, title: String, meters: [Meter] = []) {
        self.id = id
        self.accountNumber = accountNumber
        self.title = title
        self.meters = meters
    }
    
    public var description: String { return "Account: \(id ?? 0000), \(accountNumber), \(title), \(meters)" }
}

public extension Account {
    static var data: [Account] {
        [
//            Account(id: 1, accountNumber: 123, title: "Example Account", meters: Meter.data),
//            Account(id: 2, accountNumber: 456, title: "Example Account 2", meters: [])
        ]
    }
}
