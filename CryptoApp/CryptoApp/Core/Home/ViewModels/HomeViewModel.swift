//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var stats: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchBarText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private var cancellables = Set<AnyCancellable>()
    
    private let dataFetcherService = DataFetcherService()
    private let portfolioDataService = PortfolioDataService()
    
    enum SortOption {
        case rank, rankReversed
        case holdings, holdingsReversed
        case price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    //MARK: - Public functions
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        dataFetcherService.getCoinsMarkets()
        dataFetcherService.getGlobalData()
        HapticManager.notification(type: .success)
    }
    
    //MARK: - Private functions
    private func addSubscribers() {
        
        //Updates allCoins
        $searchBarText
            .combineLatest(dataFetcherService.$allCoins, $sortOption)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                guard let self else { return }
                self.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //Updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(convertPortfolioEntityToCoinModel)
            .sink { [weak self] returnedPortfolioCoins in
                guard let self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedPortfolioCoins)
            }
            .store(in: &cancellables)
        
        //Updates stats
        dataFetcherService.$globalData
            .combineLatest($portfolioCoins)
            .map(convertMarketDataToStatisticModel)
            .sink { [weak self] statistics in
                guard let self else { return }
                self.stats = statistics
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coinsArray: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(text: text, coinsArray: coinsArray)
        sortCoins(coins: &filteredCoins, sortOption: sortOption)
        return filteredCoins
    }
    
    private func filterCoins(text: String, coinsArray: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coinsArray
        }
        let lowercasedText = text.lowercased()
        return coinsArray.filter {
            $0.symbol.lowercased().contains(lowercasedText) ||
            $0.name.lowercased().contains(lowercasedText) ||
            $0.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(coins: inout [CoinModel], sortOption: SortOption){
        switch sortOption {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // sorted only by holdings because rest of them we already sorted in first subscriber
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
    
    private func convertMarketDataToStatisticModel(globalData: GlobalData, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        guard let marketData = globalData.data else { return []}
        
        let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: marketData.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
        
        let portfolioValue = updatePortfolioStatistic(portfolioCoins: portfolioCoins)

        return [marketCap, volume, btcDominance, portfolioValue]
    }
    
    private func updatePortfolioStatistic(portfolioCoins: [CoinModel]) -> StatisticModel {
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        
        let previosValue = portfolioCoins
            .map { (coin) -> Double in
                let currentvalue = coin.currentHoldingsValue
                let percentageValue = (coin.priceChangePercentage24H ?? 0) / 100
                let previosValue = currentvalue / (1 + percentageValue)
                return previosValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previosValue) / previosValue) * 100
        
        return StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
    }
    
    private func convertPortfolioEntityToCoinModel(coinModels: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        coinModels.compactMap { coin in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
}
