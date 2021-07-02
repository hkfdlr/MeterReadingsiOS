//
//  File.swift
//  
//
//  Created by Student on 02.07.21.
//

import Foundation

public class ConcreteGetAccountCommand : GetAccountCommand {
    
    var accountGetter: AccountGetter
    
    public init (accountGetter: AccountGetter) {
        self.accountGetter = accountGetter
    }
    
    public func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void) throws {
        debugPrint("getting accounts... ")
        try accountGetter.getAccounts() {
            debugPrint("ConcreteGetAccountCommand: ", $0)
            completion($0)
        }
        
    }
    
    
    
    
}
