//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }.environmentObject(viewModel)
        }
    }
}
