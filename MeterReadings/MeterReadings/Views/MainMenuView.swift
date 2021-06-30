//
//  MainMenuView.swift
//  MeterReadings
//
//  Created by Student on 03.06.21.
//

import SwiftUI
import MeterReadingsCore

struct MainMenuView: View {
    @Binding var accountsList: [Account]
    var body: some View {
        TabView {
            AccountsOverviewView(accountsList: $accountsList)
                .tabItem {
                    ZStack {
                        Image("home")
                            .resizable()
                            .scaledToFit()
                    }
                    Text("Home")
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
            MainMenuView(accountsList: .constant(Account.data))
                .previewDevice("iPhone 7")
        }
    }
}
