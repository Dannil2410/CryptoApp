//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import SwiftUI

struct SettingsView: View {
    
    private let coinGeckoURL = URL(string: "https://www.coingecko.com")!
    private let githubURL = URL(string: "https://github.com/Dannil2410")!
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    coinGeckoSection
                    developerSection
                }
                .listStyle(.grouped)
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XmarkButton()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftFulThinking course on YouTube. It uses MVVM Architecture, Combine, CoreData and FileManager!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.tint)
            }
            VStack(alignment: .leading) {
                Text("If you want get a lot of knowledges about Swift and SwiftUI, you should to subscribe on this channel:")
//                Link("SwiftFul Thinking 🥳", destination: youtubeURL)
                    .foregroundColor(Color.blue)
                    .padding(.top, 1)
            }
            .font(.headline)
            
        } header: {
            Text("Swiftful Thinking")
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrencies data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.tint)
            }
            Link("Visit CoinGecko 🦎", destination: coinGeckoURL)
                .foregroundColor(Color.blue)
            .font(.headline)
            
        } header: {
            Text("CoinGecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("KizelschteynDaniil")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Kizelschteyn Daniil. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.tint)
            }
            Link("My others projects 🤌", destination: githubURL)
                .foregroundColor(Color.blue)
            .font(.headline)
            
        } header: {
            Text("Developer")
        }
    }
}
