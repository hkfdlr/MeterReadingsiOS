//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public class ConcreteDeleteAccountCommand: DeleteAccountCommand {
    
    var accountDeleter: AccountDeleter
    
    public init(accountDeleter: AccountDeleter) {
        self.accountDeleter = accountDeleter
    }
    
    public func deleteAccount(account: Account, completion: @escaping (Result<String, Error>) -> Void) throws {
        try accountDeleter.deleteAccount(account: account, completion: completion)
    }
}
