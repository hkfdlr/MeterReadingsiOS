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
    @EnvironmentObject var viewModel: AccountsOverviewViewModel
  
    @State var enteredAccountTitle = ""
    @State var enteredAccountNumber = ""
   
    @State var meterTypes: [MeterType] = []
    @State var selectedMeterType: MeterType = MeterType.power
    @State private var showingAlert = false
        
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.accountsList, content: {
                    account in
                    NavigationLink(destination:AccountDetailView()
                                    .environmentObject(AccountDetailViewModel(account: account))) {
                        AccountRow(account: account)
                    }
                })
                .onDelete(perform: {
                    viewModel.deleteAccount(at: $0)
                })
            }
            
            .navigationTitle("MR.READINGS.TITLE")
            .toolbar {
                Button("Add", action: {
                    showAlert()
                })
            }
        }
        .onAppear {
            do {
                try viewModel.getAllAccounts()
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Add Account", message: "Please enter a name for your account and its account number", preferredStyle: .alert)
        
        alert.addTextField { accTitle in
            accTitle.text = self.enteredAccountTitle
            accTitle.placeholder = "Account name"
        }
        alert.addTextField { accNo in
            accNo.keyboardType = UIKeyboardType.numbersAndPunctuation
            accNo.text = self.enteredAccountNumber
            accNo.placeholder = "Account number"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            var newAccount = Account(id: nil, accountNumber: Int(alert.textFields![1].text!)!, title: alert.textFields![0].text!)
            do {
                try viewModel.saveAccount(account: &newAccount)
                try viewModel.getAllAccounts()
            } catch {
                debugPrint(error)
            }
        })
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}



struct AccountsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsOverviewView()
            .previewDevice("iPhone 7")
    }
}
