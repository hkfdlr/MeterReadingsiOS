//
//  File.swift
//  
//
//  Created by Student on 04.07.21.
//

import Foundation

public class ConcreteDeleteMeterCommand: DeleteMeterCommand {
    
    var meterDeleter: MeterDeleter
    
    public init(meterDeleter: MeterDeleter) {
        self.meterDeleter = meterDeleter
    }
    
    public func deleteMeter(meter: Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        try meterDeleter.deleteMeter(meter: meter, completion: completion)
    }
}
