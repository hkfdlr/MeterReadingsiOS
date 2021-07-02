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
//                t.autoIncrementedPrimaryKey("id")
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("accountNumber", .numeric)
                    .notNull()
                    .unique()
            }
            
            try db.create(table: "meter") { t in
                t.autoIncrementedPrimaryKey("id")
                    .notNull()
                t.column("accountNumber", .integer)
                    .notNull()
                    .references("account", onDelete: .cascade)
                t.column("meterNumber", .integer)
                    .notNull()
//                    .references("meterReading", column: "meterNumber", onDelete: .setNull)
                t.column("title", .text)
                t.column("meterType", .text).notNull()
            }
            
//            try db.create(table: "meterReading") { t in
//                t.autoIncrementedPrimaryKey("id")
//                    .notNull()
//                t.column("meterNumber")
//                    .notNull()
//                    .references("meter", onDelete: .cascade)
//                t.column("date", .date)
//                t.column("readingValue", .integer)
//            }
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
    
    func deleteAccount(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Account.deleteOne(db, key: id)
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
}
