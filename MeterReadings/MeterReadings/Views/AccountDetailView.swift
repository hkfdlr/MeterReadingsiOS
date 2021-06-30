//
//  AccountDetailView.swift
//  MeterReadings
//
//  Created by Student on 10.06.21.
//

import SwiftUI
import MeterReadingsCore

struct AccountDetailView: View {
    @Binding var account: Account
    @State var meterList: [Meter]
    @State private var data: Account.Data = Account.Data()
    
    var body: some View {
        List {
            ForEach(meterList) {
                meter in
                MeterRow(meter: meter)
            }
        }
        .navigationBarTitle(account.title)
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(account: .constant(Account.data[0]), meterList: Meter.data
        )
    }
}
