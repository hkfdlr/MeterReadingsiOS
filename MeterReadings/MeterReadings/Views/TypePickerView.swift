//
//  TypePickerView.swift
//  MeterReadings
//
//  Created by Student on 03.07.21.
//

import SwiftUI
import MeterReadingsCore

struct TypePickerView: View {
    var data = MeterType.allCases
    @Binding var selectedType: MeterType
    
    var body: some View {
        VStack{
            Picker("TypePicker", selection: $selectedType) {
                ForEach(data, id: \.self) {
                    Text($0.rawValue)
                }
            }
        }
        .frame(width: 200, height: 100
        )
        .clipped()
    }
}
