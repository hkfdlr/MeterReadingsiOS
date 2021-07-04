//
//  ChartView.swift
//  MeterReadings
//
//  Created by Student on 03.06.21.
//

import SwiftUI
import SwiftUICharts
import MeterReadingsCore
import MeterReadingsInfrastructure

struct ChartView: View {
    @EnvironmentObject var viewModel: ChartViewModel
    
    @State var showSheet: Bool = false
    var selectedChartIndex = 0
    
    @State var sheetEnteredValue: Double = 0
    @State var sheetPickedDate: Date = Date()
    @State var sheetConfirmed: Bool = false
        
    var body: some View {
        VStack {
            LineView(data: viewModel.readingDataSortedByDate)
                .padding(.all, 12)
        }
        .sheet(isPresented: $showSheet, onDismiss:{
            sheetDismissed(readingValue: $sheetEnteredValue.wrappedValue, pickedDate: $sheetPickedDate.wrappedValue)
        }) {
            AddEntrySheet(isShowingSheet: $showSheet, sheetConfirmed: $sheetConfirmed ,enteredValue: $sheetEnteredValue, pickedDate: $sheetPickedDate)
        }
        .navigationTitle(viewModel.meter.title)
        .navigationBarItems(trailing:
            Button("Add", action: {
                sheetConfirmed = false
                showSheet.toggle()
            })
        )
        .onAppear(perform: {
            do {
                try viewModel.getAllReadings(meterNumber: viewModel.meter.meterNumber)
            } catch {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func sheetDismissed(readingValue: Double, pickedDate: Date) {
        if (readingValue < viewModel.readingDataSortedByDate.max() ?? 0) {
            debugPrint("New value has to be greater than previous values")
            return }
        var newReading = MeterReadingEntry(id: nil, meterNumber: viewModel.meter.meterNumber, date: pickedDate, readingValue: readingValue)
        do {
            if (sheetConfirmed == true) {
                try viewModel.saveReading(reading: &newReading)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func convertMeterReadingEntries(meter: Meter) -> [Double] {
        let sortedReadings = meter.meterReadingEntries.sorted {
            $0.date > $1.date
        }

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
    
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ChartViewModel(meter: Meter(id: nil, meterNumber: 123, accountNumber: 123, title: "Title", meterType: MeterType.gas, meterReadingEntries: [])))
    }
}
