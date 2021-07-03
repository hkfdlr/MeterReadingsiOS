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
    @Binding var meter: Meter
    @State var showSheet: Bool = false
    var selectedChartIndex = 0
    
    let readingSaver = ConcreteSaveReadingCommand(readingSaver: SaveReadingAdapter())
    let readingGetter = ConcreteGetReadingCommand(readingGetter: GetReadingAdapter())
    
    @State var sheetEnteredValue: Double = 0
    @State var sheetPickedDate: Date = Date()
    @State var readingDataSortedByDate: [Double] = []
    @State var readingData: [MeterReadingEntry] = []
    @State var sheetConfirmed: Bool = false
        
    var body: some View {
        VStack {
            LineView(data: readingDataSortedByDate)
                .padding(.all, 12)
        }
        .sheet(isPresented: $showSheet, onDismiss:{
            sheetDismissed(readingValue: $sheetEnteredValue.wrappedValue, pickedDate: $sheetPickedDate.wrappedValue)
        }) {
            AddEntrySheet(isShowingSheet: $showSheet, sheetConfirmed: $sheetConfirmed ,enteredValue: $sheetEnteredValue, pickedDate: $sheetPickedDate)
        }
        .navigationTitle(self.meter.title)
        .navigationBarItems(trailing:
            Button("Add", action: {
                sheetConfirmed = false
                showSheet.toggle()
            })
        )
        .onAppear(perform: {
            do {
                try getAllReadings(meterNumber: meter.meterNumber)
            } catch {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func sheetDismissed(readingValue: Double, pickedDate: Date) {
        var newReading = MeterReadingEntry(id: nil, meterNumber: meter.meterNumber, date: pickedDate, readingValue: readingValue)
        do {
            if (sheetConfirmed == true) {
                try saveReading(reading: &newReading)
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

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(meter: .constant(Account.data[0].meters[0]), sheetEnteredValue: 0, sheetPickedDate: Date())
    }
}
