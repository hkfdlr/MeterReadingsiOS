//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public protocol AccountDeleter {
    func deleteAccount(account: Account, completion: @escaping (Result<String, Error>) -> Void) throws
}
