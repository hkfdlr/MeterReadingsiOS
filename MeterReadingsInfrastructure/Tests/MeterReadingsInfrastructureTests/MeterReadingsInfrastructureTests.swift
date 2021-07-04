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

final class MeterReadingsInfrastructureTests: XCTestCase {
    
    func testSaveGetDeleteAccount() {
        var accountToSave = Account(id: nil, accountNumber: 1, title: "Title", meters: [])
        let accountSaver = mockSaveAccountAdapter()
        do {
            try accountSaver.saveAccount(account: &accountToSave) {
                switch $0 {
                case let .success(value): debugPrint(value)
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        var accountsGotten: [Account] = []
        let accountGetter = mockGetAccountAdapter()
        do {
            try accountGetter.getAccounts(completion: {
                switch $0 {
                case let .success(accounts): do {
                    //Get first element, since there should only be one, then strip of ID, because this is set by DB
                    accountsGotten = accounts
                    let receivedAccountsStripped = [Account(id: nil, accountNumber: accounts[0].accountNumber, title: accounts[0].title, meters: accounts[0].meters)]
                    XCTAssertEqual(receivedAccountsStripped[0], accountToSave)
                }
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
        let accountDeleter = mockDeleteAccountAdapter()
        do {
            try accountDeleter.deleteAccount(account: accountsGotten[0], completion: {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Successfully deleted Account: \(accountsGotten[0])")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSaveGetDeleteMeter() {
        var accountToSave = Account(id: nil, accountNumber: 1, title: "Title", meters: [])
        let accountSaver = mockSaveAccountAdapter()
        do {
            try accountSaver.saveAccount(account: &accountToSave) {
                switch $0 {
                case let .success(value): debugPrint(value)
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        var accountsGotten: [Account] = []
        let accountGetter = mockGetAccountAdapter()
        do {
            try accountGetter.getAccounts(completion: {
                switch $0 {
                case let .success(accounts): do {
                    //Get first element, since there should only be one, then strip of ID, because this is set by DB
                    accountsGotten = accounts
                    let receivedAccountsStripped = [Account(id: nil, accountNumber: accounts[0].accountNumber, title: accounts[0].title, meters: accounts[0].meters)]
                    XCTAssertEqual(receivedAccountsStripped[0], accountToSave)
                }
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
        let accountDeleter = mockDeleteAccountAdapter()
        do {
            try accountDeleter.deleteAccount(account: accountsGotten[0], completion: {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Successfully deleted Account: \(accountsGotten[0])")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            })
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
