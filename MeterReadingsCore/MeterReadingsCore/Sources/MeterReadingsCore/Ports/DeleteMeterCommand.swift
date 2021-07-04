//
//  File.swift
//  
//
//  Created by Student on 04.07.21.
//

import Foundation

public protocol DeleteMeterCommand {
    func deleteMeter(meter: Meter, completion: @escaping (Result <String,Error>) -> Void) throws
}
