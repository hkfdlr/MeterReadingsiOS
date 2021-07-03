//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public class ConcreteGetReadingCommand: GetReadingCommand {
    
    var readingGetter: ReadingGetter
    
    public init (readingGetter: ReadingGetter) {
        self.readingGetter = readingGetter
    }
    
    public func getReadings(meterNumber: Int, completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws {
        try readingGetter.getReadings(meterNumber: meterNumber) {
            completion($0)
        }
    }
    
    
}
