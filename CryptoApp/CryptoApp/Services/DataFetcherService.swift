//
//  DataFetcherService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine
import SwiftUI

protocol DataFetcher {
    var allCoinsPublisher: AnyPublisher<[CoinModel], Never> { get }
    var globalDataPublisher: AnyPublisher<GlobalData, Never> { get }
    func getCoinsMarkets()
    func getGlobalData()
}

final class DataFetcherService: DataFetcher {
    
    private var allCoinsSubject = PassthroughSubject<[CoinModel], Never>()
    private var globalDataSubject = PassthroughSubject<GlobalData, Never>()
    private var coinSubscription: AnyCancellable?
    private var globalDataSubscription: AnyCancellable?
    private let networkService: Networking
    
    var allCoinsPublisher: AnyPublisher<[CoinModel], Never> {
        allCoinsSubject
            .eraseToAnyPublisher()
    }
    
    var globalDataPublisher: AnyPublisher<GlobalData, Never> {
        globalDataSubject
            .eraseToAnyPublisher()
    }
    
    init(networkService: Networking) {
        self.networkService = networkService
    }
    
    func getCoinsMarkets() {
        coinSubscription?.cancel()
        guard let url = CoinGeckoAPI.getCoinsMarketsURL() else { return }
        
        coinSubscription = networkService.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: networkService.completion,
                receiveValue: { [weak self] returnedCoins in
                    guard let self else { return }
                    self.allCoinsSubject.send(returnedCoins)
                })
    }
    
    func getGlobalData() {
        globalDataSubscription?.cancel()
        guard let url = CoinGeckoAPI.getGlobalDataURL() else { return }
        
        globalDataSubscription = networkService.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: networkService.completion,
                receiveValue: { [weak self] returnedGlobalData in
                    guard let self else { return }
                    globalDataSubject.send(returnedGlobalData)
                })
    }
}

extension DataFetcherService {
    
    struct CoinGeckoAPI {
        private static let scheme = "https"
        private static let host = "api.coingecko.com"
        private static let path = "/api/v3/"
        
        
        static func getCoinsMarketsURL() -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path + "coins/markets"
            
            let queryItems = [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "250"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "sparkline", value: "true"),
                URLQueryItem(name: "price_change_percentage", value: "24h"),
                URLQueryItem(name: "locale", value: "en"),
                URLQueryItem(name: "x_cg_demo_api_key", value: "CG-Z9xuwgM5gF6dtxrskoqqvRdi")
            ]
            
            components.queryItems = queryItems
            return components.url
        }
        
        static func getGlobalDataURL() -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path + "global"
            
            return components.url
        }
    }
}
