//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public class ConcreteSaveReadingCommand: SaveReadingCommand {
    var readingSaver: ReadingSaver
    
    public init (readingSaver: ReadingSaver) {
        self.readingSaver = readingSaver
    }
    
    public func saveReading(reading: inout MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws {
        try readingSaver.saveReading(reading: &reading, completion: completion)
    }
}
