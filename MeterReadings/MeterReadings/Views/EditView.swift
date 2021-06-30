//
//  EditView.swift
//  MeterReadings
//
//  Created by Student on 12.06.21.
//

import SwiftUI
import Combine
import MeterReadingsCore

struct EditView: View {
    @Binding var accountData: Account.Data
    @State private var accountNumber = ""
    
    var body: some View {
        List {
            Section(header: Text("Account Info")) {
                TextField("Title", text: $accountNumber)
                    .keyboardType(.numberPad)
                    .onReceive(Just(accountNumber)) { value in
                        let filtered = value.filter { "0123456789".contains($0) }
                        if filtered != value {
                            self.accountNumber = filtered
                        }
                    }
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView(accountData: .constant(Account.data[0]))
//    }
//}
