//
//  MainMenuView.swift
//  MeterReadings
//
//  Created by Student on 03.06.21.
//

import SwiftUI
import MeterReadingsCore

struct MainMenuView: View {
    @Binding var account: Account
    var body: some View {
        TabView {
            AccountDetailView(account: $account, meterList: account.meters)
                .tabItem {
                    ZStack {
                        Image("home")
                            .resizable()
                            .scaledToFit()
                    }
                    Text("Home")
                }
            ChartView(meters: .constant(account.meters))
                .environmentObject(ChartViewModel())
                .tabItem {
                    Image("chart")
                        .resizable()
                        .scaledToFit()
                    Text("Graph")
                }
            SettingsView()
                .environmentObject(SettingsViewModel())
                .tabItem {
                    Image("settings")
                        .resizable()
                        .scaledToFit()
                    Text("Settings")
                }
        }
        .accentColor(.blue)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainMenuView(account: .constant(Account.data[0]))
                .previewDevice("iPhone 7")
        }
    }
}
