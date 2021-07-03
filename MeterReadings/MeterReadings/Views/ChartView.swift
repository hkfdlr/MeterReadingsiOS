//
//  ChartView.swift
//  MeterReadings
//
//  Created by Student on 03.06.21.
//

import SwiftUI
import SwiftUICharts
import MeterReadingsCore

struct ChartView: View {
    @Binding var meter: Meter
    var selectedChartIndex = 0
    
    var body: some View {
        VStack {
            LineView(data: convertMeterReadingEntries(meter: meter))
                .padding(.all, 12)
        }
        .navigationTitle(self.meter.title)
    }
    
    func convertMeterReadingEntries(meter: Meter) -> [Double] {
        let sortedReadings = meter.meterReadingEntries.sorted {
            $0.date > $1.date
        }

        debugPrint(meter.meterReadingEntries)
        debugPrint(sortedReadings)
        var entryValues: [Double] = []
        var entryIndex: Int
        for reading in sortedReadings {
            entryIndex = sortedReadings.firstIndex(where: {
                $0.meterNumber == reading.meterNumber
            })!
            entryValues.insert(Double(reading.readingValue), at: entryIndex)
        }
        return entryValues
    }
    
    func saveReading(reading: inout MeterReadingEntry) throws {
        
    }
    
    func getAllReadings(meterNumber: Int) throws {
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(meter: .constant(Account.data[0].meters[0]))
    }
}
