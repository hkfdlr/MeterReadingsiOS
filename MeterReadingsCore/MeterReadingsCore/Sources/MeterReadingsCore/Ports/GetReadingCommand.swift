//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public protocol GetReadingCommand {
    func getReadings(meterNumber: Int, completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws
}
