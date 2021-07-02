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
        
    var account = Account(id: nil, accountNumber: 123123, title: "some account")
    
    @State var enteredAccountTitle = ""
    @State var enteredAccountNumber = ""

    let accountSaver = ConcreteSaveAccountCommand(accountSaver: SaveAccountAdapter())
    let accountGetter = ConcreteGetAccountCommand(accountGetter: GetAccountAdapter())
    
    @State var meterTypes: [MeterType] = []
    @State var selectedMeterType: MeterType = MeterType.power
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("", text: self.$enteredAccountTitle)
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

                //Needs to be attached to an element in the view, otherwise it's not shown, when showingAlert is true

            }
            .navigationTitle("MR.READINGS.TITLE")
            .toolbar {
                Button("Add", action: {
                    showAlert()
                })
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
                try saveAccount(account: &newAccount)
                try getAllAccounts()
            } catch {
                debugPrint(error)
            }
        })

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func saveAccount(account: inout Account) throws {
        try accountSaver.saveAccount(account: &account) {
            switch $0{
            case let .success(value): debugPrint(value)
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
    }
    
    func getAllAccounts() throws {
        try accountGetter.getAccounts {
            switch $0 {
            case let .success(value): do {
                debugPrint("ye? ", value)
                self.accountsList = value
            }
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func binding(for account: Account) -> Binding<Account> {
        guard let accountIndex = accountsList.firstIndex(where: { $0.accountNumber == account.accountNumber }) else {
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
