//
//  File.swift
//  
//
//  Created by Student on 01.07.21.
//

import Foundation

public class ConcreteSaveAccountCommand : SaveAccountCommand {
    
    var accountSaver: AccountSaver
    
    public init (accountSaver: AccountSaver) {
        self.accountSaver = accountSaver
    }
    
    public func saveAccount(account: inout Account, completion: @escaping (Result<String, Error>) -> Void) throws {
        try accountSaver.saveAccount(account: &account, completion: completion)
    }
}
