import XCTest
@testable import MeterReadingsInfrastructure
import MeterReadingsCore

//MARK: Account Mocks

class mockSaveAccountAdapter: SaveAccountAdapter {
    override func saveAccount(account: inout Account, completion: @escaping (Result<String,Error>) -> Void) throws {
        try AppDatabase.testShared.saveAccount(&account, completion: {
            completion($0)
        })
    }
}

class mockGetAccountAdapter: GetAccountAdapter {
    override func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void) throws {
        try AppDatabase.testShared.getAllAccounts(completion: {
            completion($0)
        })
    }
}

class mockDeleteAccountAdapter: DeleteAccountAdapter {
    override func deleteAccount(account: Account, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.testShared.deleteAccount(account: account) {
            completion($0)
        }
    }
}

class mockSaveMeterAdapter: SaveMeterAdapter {
    override func saveMeter(meter: inout Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.testShared.saveMeter(&meter, completion: {
            completion($0)
        })
    }
}

class mockGetMeterAdapter: GetMeterAdapter {
    override func getMeters(accountNumber: Int, completion: @escaping (Result<[Meter], Error>) -> Void) throws {
        try AppDatabase.testShared.getAllMeters(accountNumber: accountNumber, completion: {
            completion($0)
        })
    }
}

class mockDeleteMeterAdapter: DeleteMeterAdapter {
    override func deleteMeter(meter: Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.testShared.deleteMeter(meter: meter, completion: {
            completion($0)
        })
    }
}

class mockSaveReadingAdapter: SaveReadingAdapter {
    override func saveReading(reading: inout MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.testShared.saveMeterReading(&reading, completion: {
            completion($0)
        })
    }
}

class mockGetReadingAdapter: GetReadingAdapter {
    override func getReadings(meterNumber: Int, completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws {
        try AppDatabase.testShared.getAllReadings(meterNumber: meterNumber, completion: {
            completion($0)
        })
    }
}
    
class mockDeleteReadingAdapter: DeleteReadingAdapter {
    override func deleteReading(reading: MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws {
        try AppDatabase.testShared.deleteReading(reading: reading, completion: {
            completion($0)
        })
    }
}


final class MeterReadingsInfrastructureTests: XCTestCase {
    
    /*  Databases are not unit-testable, these tests still
        provide some insight and test capabilites of the DB.
        IMPORTANT
        Becuase the tables used in this DB are linked
        the tests have to be executed one after another.
     */
    
    func testInit() {
        do {
            try AppDatabase.testShared.dropAllTables()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    var accountToSave = Account(id: nil, accountNumber: 1, title: "Title", meters: [])
    var accountsGotten: [Account] = []
    var accountToDelete = Account(id: nil, accountNumber: 1, title: "Title", meters: [])
    
    func testSaveAccount() {
        let accountSaver = mockSaveAccountAdapter()
        var completionVal: String = ""
        do {
            try accountSaver.saveAccount(account: &accountToSave) {
                switch $0 {
                case let .success(value): completionVal = value
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        debugPrint(completionVal)
        XCTAssertEqual(completionVal, "Successfully saved account: \(self.accountToSave)")

    }
    
    func testGetAccount() {
        let accountGetter = mockGetAccountAdapter()
        do {
            try accountGetter.getAccounts(completion: {
                switch $0 {
                case let .success(accounts): do {
                    //Get first element, since there should only be one, then strip of ID, because this is set by DB
                    self.accountsGotten = accounts
                    let receivedAccountsStripped = [Account(id: nil, accountNumber: accounts[0].accountNumber, title: accounts[0].title, meters: accounts[0].meters)]
                    XCTAssertEqual(receivedAccountsStripped[0], self.accountToSave)
                }
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
        accountToDelete = self.accountsGotten[0]
        debugPrint("!!!", accountToDelete)
    }
    
    var meterToSave = Meter(id: nil, meterNumber: 1, accountNumber: 1, title: "", meterType: MeterType.gas, meterReadingEntries: [])
    var metersGotten: [Meter] = []
    var meterToDelete = Meter(id: nil, meterNumber: 1, accountNumber: 1, title: "", meterType: MeterType.gas, meterReadingEntries: [])
    
    func testSaveMeter() {
        let accountSaver = mockSaveAccountAdapter()
        let meterSaver = mockSaveMeterAdapter()
        var completionVal: String = ""
        do {
           
            try meterSaver.saveMeter(meter: &meterToSave) {
                switch $0 {
                case let .success(value): completionVal = value
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        XCTAssertEqual(completionVal, "Successfully saved meter: \(self.meterToSave)")

    }
    
    func testGetMeter() {
        let meterGetter = mockGetMeterAdapter()
        do {
            try meterGetter.getMeters(accountNumber: accountToSave.accountNumber, completion: {
                switch $0 {
                case let .success(meters): do {
                    debugPrint("meter gotten: ", meters)
                    self.metersGotten = meters
                    let metersGottenStripped = [Meter(id: nil, meterNumber: meters[0].meterNumber, accountNumber: meters[0].accountNumber, title: meters[0].title, meterType: meters[0].meterType, meterReadingEntries: [])]
                    XCTAssertEqual(metersGottenStripped[0], self.meterToSave)
                }
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
        meterToDelete = self.metersGotten[0]
    }
    
    var readingToSave = MeterReadingEntry(id: nil, meterNumber: 1, date: Date(timeIntervalSince1970: 0), readingValue: 1)
    var readingsGotten: [MeterReadingEntry] = []
    var readingToDelete = MeterReadingEntry(id: nil, meterNumber: 1, date: Date(timeIntervalSince1970: 0), readingValue: 1)
    
    func testSaveReading() {
        let readingSaver = mockSaveReadingAdapter()
        var completionVal: String = ""
        do {
            try readingSaver.saveReading(reading: &readingToSave, completion: {
                switch $0 {
                case let .success(value): completionVal = value
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
        XCTAssertEqual(completionVal, "Successfully saved reading: \(self.readingToSave)")
    }
    
    func testGetReading() {
        let readingGetter = mockGetReadingAdapter()
        do {
            try readingGetter.getReadings(meterNumber: meterToSave.meterNumber, completion: {
                switch $0 {
                case let .success(readings): do {
                    self.readingsGotten = readings
                    debugPrint("!!!", readings, self.readingsGotten)
                    let readingsGottenStripped = [MeterReadingEntry(
                                                    id: nil,
                                                    meterNumber: self.readingsGotten[0].meterNumber,
                                                    date: self.readingsGotten[0].date,
                                                    readingValue: self.readingsGotten[0].readingValue)]
                    XCTAssertEqual(readingsGottenStripped[0], self.readingToSave)
                }
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
        readingToDelete = self.readingsGotten[0]
    }
    
    func testDeleteReading() {
        let readingDeleter = mockDeleteReadingAdapter()
        do {
            try readingDeleter.deleteReading(reading: readingToDelete, completion: {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Successfully deleted reading: \(self.readingToDelete)")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteMeter() {
        let meterDeleter = mockDeleteMeterAdapter()
        do {
            try meterDeleter.deleteMeter(meter: meterToDelete, completion: {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Successfully deleted meter: \(self.meterToDelete)")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteAccount() {
        let accountDeleter = mockDeleteAccountAdapter()
        do {
            try accountDeleter.deleteAccount(account: accountToDelete, completion: {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Successfully deleted Account: \(self.accountToDelete)")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
