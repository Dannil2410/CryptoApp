//
//  DataFetcherService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine
import SwiftUI

final class DataFetcherService {
    
    @Published var allCoins: [CoinModel] = []
    @Published var globalData: GlobalData = GlobalData.blankObject
    private var coinSubscription: AnyCancellable?
    private var globalDataSubscription: AnyCancellable?
    
    init() {
        getCoinsMarkets()
        getGlobalData()
    }
    
    func getCoinsMarkets() {
        coinSubscription?.cancel()
        guard let url = CoinGeckoAPI.getCoinsMarketsURL() else { return }
        
        coinSubscription = NetworkManager.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkManager.completion,
                receiveValue: { [weak self] returnedCoins in
                    guard let self else { return }
                    self.allCoins = returnedCoins
                })
    }
    
    func getGlobalData() {
        globalDataSubscription?.cancel()
        guard let url = CoinGeckoAPI.getGlobalDataURL() else { return }
        
        globalDataSubscription = NetworkManager.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkManager.completion,
                receiveValue: { [weak self] returnedGlobalData in
                    guard let self else { return }
                    self.globalData = returnedGlobalData
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
                URLQueryItem(name: "x_cg_demo_api_key", value: "CG-bUv9QaFg7gjkGBtudAAiv57G")
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
