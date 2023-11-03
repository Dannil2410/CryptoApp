//
//  CoinGeckoAPIMaker.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import Foundation

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
    
    static func getCoinDetailsURL(forCoinId coinId: String) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + "coins/\(coinId)"
        
        let queryItems = [
            URLQueryItem(name: "localization", value: "false"),
            URLQueryItem(name: "tickers", value: "false"),
            URLQueryItem(name: "market_data", value: "false"),
            URLQueryItem(name: "community_data", value: "false"),
            URLQueryItem(name: "developer_data", value: "false"),
            URLQueryItem(name: "sparkline", value: "false")
        ]
        
        components.queryItems = queryItems
        return components.url
    }
}
