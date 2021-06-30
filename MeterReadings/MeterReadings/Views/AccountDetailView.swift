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
                NavigationLink(destination: ChartView(meter: binding(for: meter))){
                    MeterRow(meter: meter)
                }
            }
        }
        .navigationTitle(self.account.title)
    }
    
    private func binding(for meter: Meter) -> Binding<Meter> {
        guard let meterIndex = meterList.firstIndex(where: { $0.id == meter.id }) else {
            fatalError("Can't find meter in array")
        }
        return $meterList[meterIndex]
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(account: .constant(Account.data[0]), meterList: Meter.data
        )
    }
}
