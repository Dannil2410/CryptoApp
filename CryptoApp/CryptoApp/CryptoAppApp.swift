//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var viewModelFactory = ViewModelFactory()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.tint)]
        UICollectionView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView(vm: viewModelFactory.makeHomeViewModel())
                        .toolbar(.hidden)
                }.environmentObject(viewModelFactory)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.opacity)
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
