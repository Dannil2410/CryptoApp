//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    private let dataFetcherService: DetailViewDataFetcher
    private var cancellables = Set<AnyCancellable>()
    
    @Published var coin: CoinModel
    @Published var overViewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    init(dataFetcherService: DetailViewDataFetcher, coin: CoinModel) {
        self.dataFetcherService = dataFetcherService
        self.coin = coin
        print("DetailViewModel")
        self.addSubsribers()
    }
    
    func loadData() {
        dataFetcherService.getCoinsDetails(forCoinId: coin.id)
        print(#function)
    }
    
    private func addSubsribers() {
        
        dataFetcherService.coinDetailsPublisher
            .combineLatest($coin)
            .map(mapCoinDetailsIntoStatistics)
            .sink { [weak self] returnedArrays in
                guard let self else { return }
                self.overViewStatistics = returnedArrays.overview
                self.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        dataFetcherService.coinDetailsPublisher
            .sink { [weak self] returnedCoinDetails in
                guard let self else { return }
                self.coinDescription = returnedCoinDetails.readableDescription
                self.websiteURL = returnedCoinDetails.links?.homepage?.first
                self.redditURL = returnedCoinDetails.links?.subredditUrl
            }
            .store(in: &cancellables)
            
    }
    
    private func mapCoinDetailsIntoStatistics(coinDetails: CoinDetailModel, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        return (setupOverview(coin: coin), setupAdditional(coinDetails: coinDetails, coin: coin))
    }
    
    private func setupOverview(coin: CoinModel) -> [StatisticModel] {
        
        let price = coin.coinCurrentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    private func setupAdditional(coinDetails: CoinDetailModel, coin: CoinModel) -> [StatisticModel] {
        
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24H High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24H Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24H Price Change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetails.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetails.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
    }
    
    
}
