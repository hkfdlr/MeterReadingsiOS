//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation
import MeterReadingsCore
import GRDB

public class GetMeterAdapter: MeterGetter {
    public init () {}
    
    public func getMeters(accountNumber: Int, completion: @escaping (Result<[Meter], Error>) -> Void) throws {
        try AppDatabase.shared.getAllMeters(accountNumber: accountNumber) {
            completion($0)
        }
    }
}
