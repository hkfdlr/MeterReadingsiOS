//
//  File.swift
//  
//
//  Created by Student on 02.07.21.
//

import Foundation

public protocol AccountSaver {
    
    func saveAccount(account: inout Account, completion: @escaping (Result<String,Error>) -> Void) throws
    
}
