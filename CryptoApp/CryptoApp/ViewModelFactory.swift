//
//  ViewModelFactory.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 02.11.2023.
//

import Foundation

final class ViewModelFactory: ObservableObject {
    private let networkManager = NetworkManager()
    
    func makeHomeViewModel() -> HomeViewModel {
        let homeViewdataFetcherService: HomeViewDataFetcher = HomeViewDataFetcherService(networkManager: networkManager)
        let portfolioDataService: PortfolioDataFetcher = PortfolioDataService()
        return HomeViewModel(dataFetcherService: homeViewdataFetcherService, portfolioDataService: portfolioDataService)
    }
    
    func makeCoinImageViewModel(forCoin coin: CoinModel) -> CoinImageViewModel {
        let localFileManager: LocalFileManagerProtocol = LocalFileManager()
        let imageFetcherService = ImageFetcherService(fileManager: localFileManager)
        return CoinImageViewModel(coinImageFetcherService: imageFetcherService, coin: coin)
    }
    
    func makeDetailViewModel(forCoin coin: CoinModel) -> DetailViewModel {
        let detailViewDataFetcherService: DetailViewDataFetcher = DetailViewDataFetcherService(networkManager: networkManager)
        return DetailViewModel(dataFetcherService: detailViewDataFetcherService, coin: coin)
    }
}
