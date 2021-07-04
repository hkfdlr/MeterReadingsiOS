import XCTest
@testable import MeterReadingsCore

// MARK: Account Mocks

class MockAccountSaver: AccountSaver {
    func saveAccount(account: inout Account, completion: @escaping (Result<String, Error>) -> Void) throws {
        completion(.success("Account saved"))
    }
}

class MockAccountGetter: AccountGetter {
    
    let accounts = [
        Account(id: 1, accountNumber: 123, title: "Title", meters: []),
        Account(id: 2, accountNumber: 234, title: "Title", meters: [])
    ]
    
    func getAccounts(completion: @escaping (Result<[Account], Error>) -> Void) throws {
        completion(.success(accounts))
    }
}
   
class MockAccountDeleter: AccountDeleter {
    func deleteAccount(account: Account, completion: @escaping (Result<String, Error>) -> Void) throws {
        if account == Account(id: 1, accountNumber: 123, title: "Title", meters: []) {
            completion(.success("Account deleted"))
        }
    }
}

// MARK: Meter Mocks

class MockMeterSaver: MeterSaver {
    func saveMeter(meter: inout Meter, completion: @escaping (Result<String, Error>) -> Void) throws {
        completion(.success("Meter saved"))
    }
}

class MockMeterGetter: MeterGetter {
    let allMeters = [
        Meter(id: 1, meterNumber: 123, accountNumber: 321, title: "Title", meterType: MeterType.power, meterReadingEntries: []),
        Meter(id: 2, meterNumber: 234, accountNumber: 123, title: "Title", meterType: MeterType.gas, meterReadingEntries: [])
    ]
    
    func getMeters(accountNumber: Int, completion: @escaping (Result<[Meter], Error>) -> Void) throws {
        let filtered = allMeters.filter({ meter in
            return meter.accountNumber == accountNumber
        })
        completion(.success(
            filtered
        ))
    }
}

// MARK: Reading Mocks

class MockReadingSaver: ReadingSaver {
    func saveReading(reading: inout MeterReadingEntry, completion: @escaping (Result<String, Error>) -> Void) throws {
        completion(.success("Reading saved"))
    }
}

class MockReadingGetter: ReadingGetter {
    let allReadings = [
        MeterReadingEntry(id: 1, meterNumber: 123, date: Date(timeIntervalSince1970: 0), readingValue: 123),
        MeterReadingEntry(id: 2, meterNumber: 123, date: Date(timeIntervalSince1970: 60000), readingValue: 357),
        MeterReadingEntry(id: 3, meterNumber: 321, date: Date(timeIntervalSince1970: 120000), readingValue: 111)
    ]
    
    func getReadings(meterNumber: Int, completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws {
        let filtered = allReadings.filter({ reading in
            return reading.meterNumber == meterNumber
        })
        completion(.success(filtered))
    }
}

final class AccountTests: XCTestCase {
    
    // MARK: Account Tests
    
    func testSaveAccount() {
        
        let saveAccountCommand = ConcreteSaveAccountCommand(accountSaver: MockAccountSaver())
        
        var newAccount = Account(id: nil, accountNumber: 123, title: "Title")
        
        do {
            try saveAccountCommand.saveAccount(account: &newAccount) {
                
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Account saved")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetAccount() {
        let getAccountCommand = ConcreteGetAccountCommand(accountGetter: MockAccountGetter())
        
        let correctAccounts = [
            Account(id: 1, accountNumber: 123, title: "Title", meters: []),
            Account(id: 2, accountNumber: 234, title: "Title", meters: [])
        ]
        
        do {
            try getAccountCommand.getAccounts {
                switch $0 {
                case let .success(accounts): XCTAssertEqual(accounts, correctAccounts)
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteAccount() {
        let deleteAccountCommand = ConcreteDeleteAccountCommand(accountDeleter: MockAccountDeleter())
        let accountToDelete = Account(id: 1, accountNumber: 123, title: "Title", meters: [])
        
        do {
            try deleteAccountCommand.deleteAccount(account: accountToDelete) {
                switch $0 {
                case let .success(value): XCTAssertEqual("Account deleted", value)
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

final class MeterTests: XCTestCase {
    
    // MARK: Meter Tests
    
    func testSaveMeter() {
        let saveMeterCommand = ConcreteSaveMeterCommand(meterSaver: MockMeterSaver())
        var newMeter = Meter(id: 1, meterNumber: 123, accountNumber: 123, title: "Title", meterType: MeterType.power, meterReadingEntries: [])
        
        do {
            try saveMeterCommand.saveMeter(meter: &newMeter) {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Meter saved")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetMeter() {
        let getMeterCommand = ConcreteGetMeterCommand(meterGetter: MockMeterGetter())
        let correctMeters = [
            Meter(id: 1, meterNumber: 123, accountNumber: 321, title: "Title", meterType: MeterType.power, meterReadingEntries: [])
        ]
        
        do {
            try getMeterCommand.getMeters(accountNumber: 321) {
                switch $0 {
                case let .success(meters): XCTAssertEqual(correctMeters, meters)
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

// MARK: Reading Tests

final class ReadingTests: XCTestCase {
        
    func testSaveReading() {
        let saveReadingCommand = ConcreteSaveReadingCommand(readingSaver: MockReadingSaver())
        var newReading = MeterReadingEntry(id: 1, meterNumber: 123, date: Date(), readingValue: 123)
        
        do {
            try saveReadingCommand.saveReading(reading: &newReading) {
                switch $0 {
                case let .success(value): XCTAssertEqual(value, "Reading saved")
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetReading() {
        let getReadingCommand = ConcreteGetReadingCommand(readingGetter: MockReadingGetter())
        let correctReadings = [MeterReadingEntry(id: 1, meterNumber: 123, date: Date(timeIntervalSince1970: 0), readingValue: 123),
                               MeterReadingEntry(id: 2, meterNumber: 123, date: Date(timeIntervalSince1970: 60000), readingValue: 357)]
        
        do {
            try getReadingCommand.getReadings(meterNumber: 123) {
                switch $0 {
                case let .success(readings): XCTAssertEqual(correctReadings, readings)
                case let .failure(error): XCTFail(error.localizedDescription)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
