//
//  AccountRow.swift
//  MeterReadings
//
//  Created by Student on 10.06.21.
//

import SwiftUI
import MeterReadingsCore

struct AccountRow: View {
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(account.title)
                .font(.headline)
            Spacer()
            HStack {
                Text(account.accountNumber.description)
                Spacer()
                Text("Meters: " + account.meters.count.description)
            }
        }
        .padding(.all, 16)
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(account: Account(id: 1, accountNumber: 1 , title: "Testy" , meters: []))
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
    }
}
