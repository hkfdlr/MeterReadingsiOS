//
//  File.swift
//
//
//  Created by Student on 01.07.21.
//

// made in accordance to GRDB.swift, see https://github.com/groue/GRDB.swift

import Foundation
import GRDB

extension AppDatabase {
    static let testShared = makeShared()
    
    private static func makeShared() -> AppDatabase {
        do {
            let fileManager = FileManager()
            let folderURL = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("database", isDirectory: true)
            try fileManager.createDirectory(at:folderURL, withIntermediateDirectories: true)
            
            let dbURL = folderURL.appendingPathComponent("testdb.sqlite")
            let dbQueue = try DatabaseQueue(path: dbURL.path)
            
            let appDatabase = try AppDatabase(dbQueue, dbQueue)
            return appDatabase
        }
        catch {
            fatalError("Unresolved error \(error)")
        }
    }
}
