//
//  File.swift
//  
//
//  Created by Student on 04.07.21.
//

import Foundation

public protocol ReadingDeleter {
    func deleteReading(reading: MeterReadingEntry, completion: @escaping (Result<String,Error>) -> Void) throws
}
