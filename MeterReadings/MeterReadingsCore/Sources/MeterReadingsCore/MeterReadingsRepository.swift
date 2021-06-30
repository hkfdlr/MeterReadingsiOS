//
//  File.swift
//  
//
//  Created by Student on 09.06.21.
//

import Foundation

public class MeterReadingsRepository : MeterReadingsRepositoryProtocol {
    
    var meterTypeProvider : MeterTypeProvider
    
    public init(meterTypeProvider: MeterTypeProvider) {
        self.meterTypeProvider = meterTypeProvider
    }
    
    public func getMeterType(completion: @escaping (Result<[MeterType], Error>) -> Void) {
        meterTypeProvider.provideMeterTypes() {
            completion($0)
        }
    }
}
