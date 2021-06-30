//
//  ReadingsView.swift
//  MeterReadings
//
//  Created by Student on 03.06.21.
//

import SwiftUI
import MeterReadingsCore
import MeterReadingsInfrastructure

struct AccountsOverviewView: View {
    @Binding var accountsList: [Account]
    @State private var newAccountData = Account.Data()
    
    @State var enteredText = ""
    @State var meterTypes: [MeterType] = []
    @State var selectedMeterType: MeterType = MeterType.power
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    List {
                        ForEach(accountsList) {
                            account in
                            NavigationLink(destination:AccountDetailView(account: binding(for: account), meterList: account.meters)) {
                                AccountRow(account: account)
                            }
                        }
                    }
                }
                TextField("MR.READINGS.ENTERTEXT", text: $enteredText)
                Button("MR.READINGS.NEWREADINGBTN") {
                    
                }
                .padding(.all, 12.0)
                .frame(width: UIScreen.main.bounds.width - 24, height: nil, alignment: .center)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom,12)
            }
            .navigationTitle("MR.READINGS.TITLE")
        }
    }
    
    func saveReading() {
        
    }
    
    private func binding(for account: Account) -> Binding<Account> {
        guard let accountIndex = accountsList.firstIndex(where: { $0.id == account.id }) else {
            fatalError("Can't find account in array")
        }
        return $accountsList[accountIndex]
    }
}

struct AccountsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsOverviewView(accountsList: .constant(Account.data))
            .previewDevice("iPhone 7")
    }
}
