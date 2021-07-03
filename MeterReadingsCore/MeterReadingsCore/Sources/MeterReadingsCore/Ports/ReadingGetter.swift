//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public protocol ReadingGetter {
    func getReadings(meterNumber: Int, completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws
}
