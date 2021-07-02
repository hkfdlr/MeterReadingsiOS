//
//  File.swift
//  
//
//  Created by Student on 09.06.21.
//

import Foundation

public protocol MeterReadingsRepositoryProtocol {

    func getMeterType(completion: @escaping (Result<[MeterType], Error>) -> Void)
}
