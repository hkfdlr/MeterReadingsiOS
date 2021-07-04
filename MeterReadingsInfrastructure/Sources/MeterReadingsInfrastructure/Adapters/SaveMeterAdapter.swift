//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class SaveMeterAdapter: MeterSaver {
    public init() { }
    
    public func saveMeter(meter: inout Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.shared.saveMeter(&meter) {
            completion($0)
        }
    }
}
