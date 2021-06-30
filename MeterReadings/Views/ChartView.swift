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
    @Binding var meters: [Meter]
    var selectedChartIndex = 0
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(meters) {
                    meter in
                    MultiLineChartView(data: [([1], GradientColors.orange
                    )],
                    title: meter.title,
                    form: ChartForm.extraLarge)
                }
            }
        }
    }
    
    func convertMeterReadingEntries(meter: Meter) {
        var entryValues: [Double] = []
        var entryIndex: Int
        for entry in meter.meterReadingEntries {
            entryIndex = meter.meterReadingEntries.firstIndex(where: {$0.id == entry.id})!
            entryValues[entryIndex] = Double(meter.meterReadingEntries[entryIndex])
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(meters: .constant(Account.data[0].meters))
    }
}
