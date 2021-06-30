//
//  File.swift
//  
//
//  Created by Student on 09.06.21.
//

import Foundation

public class MeterTypeProvider {
    
    public init() {
        
    }
    
    func provideMeterTypes(completion: @escaping (Result<[MeterType], Error>) -> Void) {
        completion(.success(MeterType.allCases))
    }
    
}
