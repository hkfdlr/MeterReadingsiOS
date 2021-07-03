//
//  AddEntrySheet.swift
//  MeterReadings
//
//  Created by Student on 03.07.21.
//

import Foundation
import SwiftUI

struct AddEntrySheet: View {
    @Binding var isShowingSheet: Bool
    @Binding var sheetConfirmed: Bool
    @Binding var enteredValue: Double
    @State var enteredIntermediateValue: String = ""
    @Binding var pickedDate: Date
    
    var body: some View {
        VStack {
            Text("Add Reading")
                .font(.title)
                .padding(50)
            TextField("Reading Value", text: $enteredIntermediateValue)
                .padding(50)
            DatePicker("Pick date", selection: $pickedDate)
                .padding(50)
            Button("Confirm", action: {
                enteredValue = Double(enteredIntermediateValue) ?? 0
                sheetConfirmed = true
                isShowingSheet.toggle()
            })
        }
    }
}
