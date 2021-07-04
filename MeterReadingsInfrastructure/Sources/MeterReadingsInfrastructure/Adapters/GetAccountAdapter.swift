//
//  File.swift
//  
//
//  Created by Student on 02.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class GetAccountAdapter: AccountGetter {
    public init() { }
    
    public func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void) throws {
        try AppDatabase.shared.getAllAccounts() {
            completion($0)
        }
    }
}
