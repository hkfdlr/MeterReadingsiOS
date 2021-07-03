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
        
        migrator.registerMigration("init v1") { db in
            try db.create(table: "account") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("accountNumber", .numeric)
                    .notNull()
                    .unique()
            }
            
            try db.create(table: "meter") { t in
                t.autoIncrementedPrimaryKey("id")
                    
                t.column("meterNumber", .integer)
                    .notNull()
                    .unique()
                t.column("accountNumber", .numeric)
                    .notNull()
                    .references("account", column: "accountNumber", onDelete: .cascade)
                t.column("title", .text)
                t.column("meterType", .text).notNull()
            }
            
            try db.create(table: "meterReading") { t in
                t.autoIncrementedPrimaryKey("id")
                    .notNull()
                t.column("meterNumber")
                    .notNull()
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
    func saveAccount(_ account: inout Account) throws {
        try dbWriter.write { db in
            try account.save(db)
        }
    }
    
    func deleteAccount(account: Account) throws {
        try dbWriter.write { db in
            _ = try Account.deleteOne(db, key: ["accountNumber": account.accountNumber])
        }
    }
    
    func saveMeter(_ meter: inout Meter) throws {
        debugPrint("writing meter: ", meter)
        try dbWriter.write { db in
            try meter.save(db)
        }
    }
    
    func saveMeterReading(_ meterReadingEntry: inout MeterReadingEntry) throws {
        try dbWriter.write { db in
            try meterReadingEntry.save(db)
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
            debugPrint("read meters: ", meters)
            completion(.success(meters))
        }
    }
    
    func getAllReadings(completion: @escaping (Result<[MeterReadingEntry], Error>) -> Void) throws {
        try dbReader.read { db in
            let readings = try MeterReadingEntry.fetchAll(db)
            completion(.success(readings))
        }
    }
}
