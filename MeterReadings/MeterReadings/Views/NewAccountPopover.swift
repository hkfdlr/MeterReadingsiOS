//
//  NewAccountPopover.swift
//  MeterReadings
//
//  Created by Student on 02.07.21.
//

import Foundation
import SwiftUI

struct NewAccountPopover: View {
    @State var firstInput: String
    @State var secondInput: String
    
    var body: some View {
        VStack{
            TextField("firstTextField", text: $firstInput)
            TextField("secondTextField", text: $secondInput)
        }
        .navigationTitle("Add Account")
        .navigationBarItems(trailing: Button("Submit"){
            
        })
    }
}
