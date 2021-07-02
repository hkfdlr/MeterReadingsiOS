//
//  File.swift
//  
//
//  Created by Student on 01.07.21.
//

import Foundation

public protocol SaveAccountCommand {
    func saveAccount(account: inout Account, completion: @escaping (Result<String,Error>) -> Void) throws
}
