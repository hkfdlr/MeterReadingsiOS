//
//  File.swift
//  
//
//  Created by Student on 02.07.21.
//

import Foundation

public protocol AccountGetter {
    
    func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void) throws
    
}
