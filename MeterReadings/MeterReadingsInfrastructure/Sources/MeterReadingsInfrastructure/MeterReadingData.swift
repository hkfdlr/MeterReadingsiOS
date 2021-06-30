//
//  File.swift
//  
//
//  Created by Student on 05.06.21.
//

import Foundation
import MeterReadingsCore

@available(iOS 13.0, *)
class MeterReadingData: ObservableObject {
    
    let meterTypes = MeterType.allCases
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileUrl: URL {
        return documentsFolder.appendingPathComponent("meterReadings.data")
    }
    @Published var meterReadingEntries: [MeterReadingEntry] = []
    
    func load() {
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            guard let data = try? Data(contentsOf: Self.fileUrl) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.meterReadingEntries = MeterReadingEntry.data
                }
                #endif
                return
            }
            guard let meterReadings = try? JSONDecoder().decode([MeterReadingEntry].self, from: data) else {
                fatalError("Can't decode saved meter readings data.")
            }
            DispatchQueue.main.async {
                self?.meterReadingEntries = meterReadings
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            guard let meterReadingEntries = self?.meterReadingEntries else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(meterReadingEntries) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileUrl
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
    
    func provideMeterTypes(completion: @escaping (Result<[MeterType], Error>) -> Void){
        completion(.success(meterTypes))
    }
}
