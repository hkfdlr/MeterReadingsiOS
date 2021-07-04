//
//  File.swift
//  MeterReadings
//
//  Created by Student on 04.07.21.
//

import Foundation
import MeterReadingsCore
import MeterReadingsInfrastructure

final class AccountsOverviewViewModel: ObservableObject {
    @Published var accountsList: [Account] = []
    
    let accountSaver = ConcreteSaveAccountCommand(accountSaver: SaveAccountAdapter())
    let accountGetter = ConcreteGetAccountCommand(accountGetter: GetAccountAdapter())
    let accountDeleter = ConcreteDeleteAccountCommand(accountDeleter: DeleteAccountAdapter())
    let meterGetter = ConcreteGetMeterCommand(meterGetter: GetMeterAdapter())
    
    func saveAccount(account: inout Account) throws {
        try accountSaver.saveAccount(account: &account) {
            switch $0{
            case let .success(value): debugPrint(value)
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
    }
    
    func deleteAccount(at index: IndexSet) {
        guard let index = index.first else { return }
        let accountToDelete = accountsList[index]
        do {
            try accountDeleter.deleteAccount(account: accountToDelete) {
                switch $0 {
                case let .success(value): debugPrint(value)
                case let .failure(error): debugPrint(error)
                }
            }
        } catch {
            debugPrint(error)
        }
        accountsList.remove(at: index)
    }
    
    func getAllAccounts() throws {
        accountsList = []
        try accountGetter.getAccounts {
            switch $0 {
            case let .success(value): do {
                for elem in value {
                    if (!self.accountsList.contains(elem)) {
                        let lastIndex = self.accountsList.endIndex
                        self.accountsList.insert(elem, at: lastIndex)
                    }
                }
            }
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
        try getMetersForAccounts()
    }
    
    func getMetersForAccounts() throws {
        for elem in accountsList {
            try meterGetter.getMeters(accountNumber: elem.accountNumber) {
                switch $0 {
                case let .success(meters): do {
                    let i = self.accountsList.firstIndex(of: elem)
                    if (i != nil) {
                        self.accountsList[i!].meters = meters
                    }
                }
                case let .failure(error): debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
