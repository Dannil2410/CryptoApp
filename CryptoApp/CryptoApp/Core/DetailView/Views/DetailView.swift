//
//  DetailView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject private var vmFactory: ViewModelFactory
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    @State private var showNavigationBar: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    
    init(vm: @autoclosure @escaping () -> DetailViewModel) {
        _vm = StateObject(wrappedValue: vm())
        print("init DetailView")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    
                    descriptionSection
                    
                    overviewSection
                    
                    additionalTitle
                    Divider()
                    
                    additionalSection
                    
                    linksSection
                }
                .padding()
                .onAppear {
                    vm.loadData()
                    showNavigationBar.toggle()
                }
            }
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar(showNavigationBar ? .visible: .hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(vm: ViewModelFactory().makeDetailViewModel(forCoin: dev.coin))
        }
        .environmentObject(dev.viewModelFactory)
    }
}

extension DetailView {
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundColor(Color.theme.secondaryText)
            
            CoinImageView(vm: vmFactory.makeCoinImageViewModel(forCoin: vm.coin))
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.tint)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        VStack {
            if let description = vm.coinDescription,
                !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? .max : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        showFullDescription.toggle()
                    } label: {
                        Text(showFullDescription ? "Less": "Read more...")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color.blue)
                            .padding(.vertical, 1)
                            .animation(.easeInOut, value: showFullDescription)
                    }

                }
            }
        }
    }
    
    private var overviewSection: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overViewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.tint)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalSection: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .font(.headline)
        .bold()
        .foregroundColor(Color.blue)
    }
}
