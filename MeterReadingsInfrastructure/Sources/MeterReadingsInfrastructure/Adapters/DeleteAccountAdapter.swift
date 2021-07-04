//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class DeleteAccountAdapter: AccountDeleter {
    public init () {}
    
    public func deleteAccount(account: Account, completion: @escaping (Result<String, Error>) -> Void ) throws {
        try AppDatabase.shared.deleteAccount(account: account) {
            completion($0)
        }
    }
}
