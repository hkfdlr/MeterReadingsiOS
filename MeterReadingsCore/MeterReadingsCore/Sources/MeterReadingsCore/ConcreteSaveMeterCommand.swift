//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public class ConcreteSaveMeterCommand : SaveMeterCommand {
    
    var meterSaver: MeterSaver
    
    public init (meterSaver: MeterSaver) {
        self.meterSaver = meterSaver
    }
    
    public func saveMeter(meter: inout Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        try meterSaver.saveMeter(meter: &meter, completion: completion)
    }
    
}
