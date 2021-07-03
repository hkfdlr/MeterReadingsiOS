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
    @State var accountsList: [Account] = []
        
    @State var enteredAccountTitle = ""
    @State var enteredAccountNumber = ""
    
    let accountSaver = ConcreteSaveAccountCommand(accountSaver: SaveAccountAdapter())
    let accountGetter = ConcreteGetAccountCommand(accountGetter: GetAccountAdapter())
    let accountDeleter = ConcreteDeleteAccountCommand(accountDeleter: DeleteAccountAdapter())
    let meterGetter = ConcreteGetMeterCommand(meterGetter: GetMeterAdapter())

    
    @State var meterTypes: [MeterType] = []
    @State var selectedMeterType: MeterType = MeterType.power
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accountsList) {
                    account in
                    NavigationLink(destination:AccountDetailView(account: binding(for: account), meterList: account.meters)) {
                        AccountRow(account: account)
                    }
                }
                .onDelete(perform: deleteAccount)
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
                try getAllAccounts()
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
    
    func deleteAccount(at index: IndexSet) {
        let accountToDelete = index.map {
            self.$accountsList[$0]
        }
        do {
            try accountDeleter.deleteAccount(account: accountToDelete[0].wrappedValue) {
                switch $0 {
                case let .success(value): debugPrint(value)
                case let .failure(error): debugPrint(error)
                }
            }
        } catch {
            debugPrint(error)
        }
        accountsList.remove(atOffsets: index)
    }
    
    func getAllAccounts() throws {
        debugPrint("accountsList before: ", self.$accountsList)
        try accountGetter.getAccounts {
            switch $0 {
            case let .success(value): do {
                for elem in value {
                    debugPrint("processing Account: ", elem)
                    if (!self.accountsList.contains(elem)) {
                        let lastIndex = self.accountsList.endIndex
                        self.accountsList.insert(elem, at: lastIndex)
                    }
                }
            }
            case let .failure(error): debugPrint(error.localizedDescription)
            }
            debugPrint("accountsList after: ", self.$accountsList)
        }
        try getMetersForAccounts()
    }
    
    func getMetersForAccounts() throws {
        for elem in accountsList {
            try meterGetter.getMeters(accountNumber: elem.accountNumber) {
                switch $0 {
                case let .success(meters): do {
                    updateMeters(acc: elem, meters: meters)
                }
                case let .failure(error): debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func updateMeters(acc: Account, meters: [Meter]) {
        let i = accountsList.firstIndex(of: acc)
        accountsList[i!].meters.append(contentsOf: meters)
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
        AccountsOverviewView()
            .previewDevice("iPhone 7")
    }
}
