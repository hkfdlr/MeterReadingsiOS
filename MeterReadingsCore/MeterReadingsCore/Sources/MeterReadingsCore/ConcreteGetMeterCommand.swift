//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public class ConcreteGetMeterCommand: GetMeterCommand {
    
    var meterGetter: MeterGetter
    
    public init (meterGetter: MeterGetter) {
        self.meterGetter = meterGetter
    }
    
    public func getMeters(accountNumber: Int, completion: @escaping (Result<[Meter], Error>) -> Void) throws {
        try meterGetter.getMeters(accountNumber: accountNumber) {
            completion($0)
        }
    }
    
    
}
