//
//  MainMenuView.swift
//  MeterReadings
//
//  Created by Student on 03.06.21.
//

import SwiftUI
import MeterReadingsCore

struct MainMenuView: View {
    var body: some View {
        TabView {
            AccountsOverviewView()
                .environmentObject(AccountsOverviewViewModel())
                .tabItem {
                    ZStack {
                        Image("home")
                            .resizable()
                            .scaledToFit()
                    }
                    Text("Home")
                }
            SettingsView()
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
            MainMenuView()
                .previewDevice("iPhone 7")
        }
    }
}
