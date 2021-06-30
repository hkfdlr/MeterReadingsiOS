//
//  File.swift
//  
//
//  Created by Student on 30.06.21.
//

import Foundation

public class MeterReadingsProvider {
    
    public init() {
        
    }
    
    func provideMeterReadings(completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) {
        completion(.success(MeterReadingEntry.data))
    }
    
}
