//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public protocol MeterGetter {
    
    func getMeters(accountNumber: Int, completion: @escaping (Result<[Meter], Error>) -> Void) throws
    
}
