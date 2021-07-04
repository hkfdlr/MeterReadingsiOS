//
//  File.swift
//  
//
//  Created by Student on 04.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class DeleteMeterAdapter: MeterDeleter {
    public init () {}
    
    public func deleteMeter(meter: Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.shared.deleteMeter(meter: meter) {
            completion($0)
        }
        
    }
}
