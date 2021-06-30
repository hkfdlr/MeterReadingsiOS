//
//  MeterReadingsApp.swift
//  MeterReadings
//
//  Created by Student on 02.06.21.
//

import SwiftUI
import MeterReadingsCore

@main
struct MeterReadingsApp: App {
    var body: some Scene {
        WindowGroup {
            AccountsOverviewView(accountsList: .constant(Account.data))
        }
    }
}
