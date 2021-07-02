//
//  File.swift
//  
//
//  Created by Student on 01.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class SaveAccountAdapter: AccountSaver {
    
    public init() { }
   
    public func saveAccount(account: inout Account, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.shared.saveAccount(&account)
    }
}
