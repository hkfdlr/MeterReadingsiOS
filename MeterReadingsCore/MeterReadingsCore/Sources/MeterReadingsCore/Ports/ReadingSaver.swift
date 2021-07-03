//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public protocol ReadingSaver {
    
    func saveReading(reading: inout MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws
    
}
