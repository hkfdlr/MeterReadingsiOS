//
//  ChartViewModel.swift
//  MeterReadings
//
//  Created by Student on 04.07.21.
//

import Foundation
import MeterReadingsCore
import MeterReadingsInfrastructure

final class ChartViewModel: ObservableObject {
    
    public init(meter: Meter) {
        self.meter = meter
    }
    
    @Published var meter: Meter
    @Published var readingDataSortedByDate: [Double] = []
    @Published var readingData: [MeterReadingEntry] = []
    
    let readingSaver = ConcreteSaveReadingCommand(readingSaver: SaveReadingAdapter())
    let readingGetter = ConcreteGetReadingCommand(readingGetter: GetReadingAdapter())
    
    func saveReading(reading: inout MeterReadingEntry) throws {
        try readingSaver.saveReading(reading: &reading, completion: {
            switch $0 {
            case let .success(value): debugPrint(value)
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        })
        try getAllReadings(meterNumber: meter.meterNumber)
    }
    
    func getAllReadings(meterNumber: Int) throws {
        try readingGetter.getReadings(meterNumber: meterNumber, completion: {
            switch $0 {
            case let .success(readings): do {
                for elem in readings {
                    if (!self.readingData.contains(elem)) {
                        let index = self.readingData.endIndex
                        self.readingData.insert(elem, at: index)
                    }
                }
            }
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        })
        sortReadingData()
    }
    
    func sortReadingData() {
        readingDataSortedByDate = []
        readingData = readingData.sorted {
            $0.date < $1.date
        }
        for entry in readingData {
            readingDataSortedByDate.append(entry.readingValue)
        }
    }
}
