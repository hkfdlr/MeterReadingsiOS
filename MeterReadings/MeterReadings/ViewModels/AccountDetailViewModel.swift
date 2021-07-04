//
//  AccountDetailViewModel.swift
//  MeterReadings
//
//  Created by Student on 04.07.21.
//

import Foundation
import MeterReadingsCore
import MeterReadingsInfrastructure

final class AccountDetailViewModel: ObservableObject {
    
    public init(account: Account) {
        self.account = account
    }
    
    @Published var account: Account
    @Published var meterList: [Meter] = []
    
    let meterSaver = ConcreteSaveMeterCommand(meterSaver: SaveMeterAdapter())
    let meterGetter = ConcreteGetMeterCommand(meterGetter: GetMeterAdapter())
    let meterDeleter = ConcreteDeleteMeterCommand(meterDeleter: DeleteMeterAdapter())
    let readingGetter = ConcreteGetReadingCommand(readingGetter: GetReadingAdapter())
    
    func deleteMeter(at index: IndexSet) {
        guard let index = index.first else {return}
        let meterToDelete = meterList[index]
        do {
            try meterDeleter.deleteMeter(meter: meterToDelete) {
                switch $0 {
                case let .success(value): debugPrint(value)
                case let .failure(error): debugPrint(error)
                }
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        meterList.remove(at: index)
    }
    
    func saveMeter(meter: inout Meter) throws {
        try meterSaver.saveMeter(meter: &meter) {
            switch $0 {
            case let .success(value): debugPrint(value)
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
        debugPrint(account)
        try getAllMeters(accountNumber: account.accountNumber)
    }
    
    func getAllMeters(accountNumber: Int) throws {
        meterList = []
        try meterGetter.getMeters(accountNumber: accountNumber) {
            switch $0 {
            case let .success(meters): do {
                for elem in meters {
                    if (!self.meterList.contains(elem)) {
                        let lastIndex = self.meterList.endIndex
                        self.meterList.insert(elem, at: lastIndex)
                    }
                }
            }
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
        try getReadingsForMeters()
    }
    
    func getReadingsForMeters() throws {
        for elem in meterList {
            try readingGetter.getReadings(meterNumber: elem.meterNumber) {
                switch $0 {
                case let .success(readings): do {
                    let i = self.meterList.firstIndex(of: elem)
                    if (i != nil) {
                        self.meterList[i!].meterReadingEntries = readings
                    }
                }
                case let .failure(error): debugPrint(error.localizedDescription)
                }
            }
        }
        debugPrint(meterList)
    }
}
