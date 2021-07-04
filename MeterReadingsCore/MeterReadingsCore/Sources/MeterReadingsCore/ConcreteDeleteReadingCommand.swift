//
//  File.swift
//  
//
//  Created by Student on 04.07.21.
//

import Foundation

public class ConcreteDeleteReadingCommand: DeleteReadingCommand {
    
    var readingDeleter: ReadingDeleter
    
    public init(readingDeleter: ReadingDeleter) {
        self.readingDeleter = readingDeleter
    }
    
    public func deleteReading(reading: MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws {
        try readingDeleter.deleteReading(reading: reading, completion: completion)
    }
}
