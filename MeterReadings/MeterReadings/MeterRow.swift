//
//  MeterRow.swift
//  MeterReadings
//
//  Created by Student on 10.06.21.
//

import SwiftUI
import MeterReadingsCore

struct MeterRow: View {
    let meter: Meter
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(meter.title)
                    .font(.headline)
                Spacer()
                Text(meter.meterType.rawValue)
            }
            Spacer()
            HStack {
                Text(meter.meterNumber.description)
                Spacer()
                Text(meter.meterReadingEntries.count.description)
            }
        }
        .padding(.all, 16)
    }
}

struct MeterRow_Previews: PreviewProvider {
    static var previews: some View {
        MeterRow(meter: Meter(meterNumber: 321, title: "Example Gas-Meter", meterType: MeterType.gas, meterReadingEntries: []))
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
    }
}
