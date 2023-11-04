//
//  HomeView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // animate appear PortfolioView
    @State private var showSettingsView: Bool = false // animate appear SettingsView
    @StateObject private var vm: HomeViewModel
    @EnvironmentObject private var vmFactory: ViewModelFactory
    
    init(vm: HomeViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView(vm: vm)
                }
            
            // content layer
            VStack {
                homeHeader
                
                HomeStatisticView(showPortfolio: $showPortfolio, vm: vm)
                
                SearchBarView(searchText: $vm.searchBarText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchBarText.isEmpty {
                            portfolioEmtyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                                    
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(vm: ViewModelFactory().makeHomeViewModel())
        }
        .environmentObject(dev.viewModelFactory)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" :  "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                        vm.searchBarText = ""
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.tint)
                .animation(.none, value: showPortfolio)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(
                    .degrees(showPortfolio ? 180 : 0)
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 180 : 0))
                }.onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 180 : 0))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                NavigationLink(value: coin) {
                    CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .navigationDestination(for: CoinModel.self) { coin in
            DetailView(vm: vmFactory.makeDetailViewModel(forCoin: coin))
        }
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                NavigationLink(value: coin) {
                    CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .navigationDestination(for: CoinModel.self) { coin in
            DetailView(vm: vmFactory.makeDetailViewModel(forCoin: coin))
        }
    }
    
    private var portfolioEmtyText: some View {
        Text("You haven't added any coins to your portfolio yet. Click the + Button to get started! 🧐")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundColor(Color.theme.tint)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}
