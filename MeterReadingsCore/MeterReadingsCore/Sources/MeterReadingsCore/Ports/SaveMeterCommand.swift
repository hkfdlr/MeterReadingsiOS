//
//  File.swift
//  
//
//  Created by Student on 03.07.21.
//

import Foundation

public protocol SaveMeterCommand {
    func saveMeter(meter: inout Meter, completion: @escaping (Result<String, Error>) -> Void) throws
}
