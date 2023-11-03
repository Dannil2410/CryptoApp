//
//  ViewModelFactory.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 02.11.2023.
//

import Foundation

final class ViewModelFactory: ObservableObject {
    private let dataFetcherService: DataFetcher = DataFetcherService(networkService: NetworkManager())
    private let portfolioDataService: PortfolioData = PortfolioDataService()
    private let localFileManager: LocalFileManagerProtocol = LocalFileManager()
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(dataFetcherService: dataFetcherService, portfolioDataService: portfolioDataService)
    }
    
    func makeCoinImageViewModel(forCoin coin: CoinModel) -> CoinImageViewModel {
        let imageFetcherService = ImageFetcherService(fileManager: localFileManager)
        return CoinImageViewModel(coinImageFetcherService: imageFetcherService, coin: coin)
    }
}
