//
//  File.swift
//  
//
//  Created by Student on 01.07.21.
//

// made in accordance to GRDB.swift, see https://github.com/groue/GRDB.swift

import Foundation
import MeterReadingsCore
import GRDB

final class AppDatabase {
    
    init(_ dbWriter: DatabaseWriter, _ dbReader: DatabaseReader) throws {
        self.dbWriter = dbWriter
        self.dbReader = dbReader
        try migrator.migrate(dbWriter)
    }
    
    private let dbWriter: DatabaseWriter
    private let dbReader: DatabaseReader
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("init v2") { db in
            try db.create(table: "account") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("accountNumber", .integer)
                    .unique()
            }
            
            try db.create(table: "meter") { t in
                t.autoIncrementedPrimaryKey("id")
                    
                t.column("meterNumber", .numeric)
                    .unique()
                t.column("accountNumber", .integer)
                    .references("account", column: "accountNumber", onDelete: .cascade
                    )
                t.column("title", .text)
                t.column("meterType", .text).notNull()
            }
            
            try db.create(table: "meterReadingEntry") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("meterNumber", .integer)
                    .references("meter", column: "meterNumber", onDelete: .cascade)
                t.column("date", .date)
                t.column("readingValue", .integer)
            }
        }
        return migrator
    }
}

// MARK: WRITING

extension AppDatabase {
    
    func dropAllTables() throws {
        try dbWriter.write { db in
            try db.drop(table: "account")
            try db.drop(table: "meter")
            try db.drop(table: "meterReadingEntry")
        }
    }
    
    func saveAccount(_ account: inout Account, completion: @escaping (Result<String,Error>) -> Void) throws {
        try dbWriter.write { db in
            try account.save(db)
            completion(.success("Successfully saved account: \(account)"))
        }
    }
    
    func deleteAccount(account: Account, completion: @escaping (Result<String,Error>) -> Void) throws {
        try dbWriter.write { db in
            _ = try Account.deleteOne(db, key: account.id)
            completion(.success("Successfully deleted Account: \(account)"))
        }
    }
    
    func saveMeter(_ meter: inout Meter, completion: @escaping (Result<String,Error>) -> Void) throws {
        try dbWriter.write { db in
            try meter.save(db)
            completion(.success("Successfully saved meter: \(meter)"))
        }
    }
    
    func deleteMeter(meter: Meter, completion: @escaping (Result<String,Error>) -> Void) throws {
        try dbWriter.write { db in
            _ = try Meter.deleteOne(db, key: meter.id)
            completion(.success("Successfully deleted meter: \(meter)"))
        }
    }
    
    func saveMeterReading(_ meterReadingEntry: inout MeterReadingEntry, completion: @escaping (Result<String,Error>) -> Void) throws {
        try dbWriter.write { db in
            try meterReadingEntry.save(db)
            completion(.success("Successfully saved reading: \(meterReadingEntry)"))
        }
    }
    
    func deleteReading(reading: MeterReadingEntry, completion: @escaping (Result<String,Error>) -> Void) throws {
        try dbWriter.write { db in
            _ = try MeterReadingEntry.deleteOne(db, key: reading.id)
            completion(.success("Successfully deleted reading: \(reading)"))
        }
    }
}

// MARK: READING

extension AppDatabase {
    func getAllAccounts(completion: @escaping (Result<[Account], Error>) -> Void) throws {
        try dbReader.read { db in
            let accounts = try Account.fetchAll(db)
            completion(.success(accounts))
        }
    }
    
    func getAllMeters(accountNumber: Int ,completion: @escaping (Result<[Meter], Error>) -> Void) throws {
        try dbReader.read { db in
            let meters = try Meter.fetchAll(db, sql: "SELECT * FROM meter WHERE accountNumber == \(accountNumber)")
            completion(.success(meters))
        }
    }
    
    func getAllReadings(meterNumber: Int ,completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws {
        try dbReader.read { db in
            let readings = try MeterReadingEntry.fetchAll(db, sql: "SELECT * FROM meterReadingEntry WHERE meterNumber == \(meterNumber)")
            completion(.success(readings))
        }
    }
}
