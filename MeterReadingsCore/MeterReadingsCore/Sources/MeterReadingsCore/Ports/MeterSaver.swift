//
//  File.swift
//
//
//  Created by Student on 02.07.21.
//

import Foundation

public protocol MeterSaver {
    
    func saveMeter(meter: inout Meter, completion: @escaping (Result<String,Error>) -> Void) throws
    
}
