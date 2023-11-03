//
//  CoinModel.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import Foundation

//CoinGecko API info
/*
 
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en
 
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en&x_cg_demo_api_key=CG-bUv9QaFg7gjkGBtudAAiv57G
 
 JSON response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
     "current_price": 34768,
     "market_cap": 677234777930,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 728273316371,
     "total_volume": 16326855420,
     "high_24h": 34787,
     "low_24h": 34174,
     "price_change_24h": 420.1,
     "price_change_percentage_24h": 1.22306,
     "market_cap_change_24h": 6160838621,
     "market_cap_change_percentage_24h": 0.91806,
     "circulating_supply": 19528287,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 69045,
     "ath_change_percentage": -49.77173,
     "ath_date": "2021-11-10T14:24:11.849Z",
     "atl": 67.81,
     "atl_change_percentage": 51043.64213,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2023-10-30T14:06:04.051Z",
     "sparkline_in_7d": {
       "price": [
         30655.669046519935,
         30653.03562485807,
         34553.54954359292
       ]
     },
     "price_change_percentage_24h_in_currency": 1.223064427286507
   }
 
 */


// MARK: - CoinModel
struct CoinModel: Identifiable, Codable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double?
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    
    // How many coins current user is holding (local property)
    let currentHoldings: Double?
    
    func updateHoldings(amount: Double) -> CoinModel {
        CoinModel(
            id: id,
            symbol: symbol,
            name: name,
            image: image,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume,
            high24H: high24H,
            low24H: low24H,
            priceChange24H: priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H,
            marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            ath: ath,
            athChangePercentage: athChangePercentage,
            athDate: athDate,
            atl: atl,
            atlChangePercentage: atlChangePercentage,
            atlDate: atlDate,
            lastUpdated: lastUpdated,
            sparklineIn7D: sparklineIn7D,
            priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
            currentHoldings: amount
        )
    }
    
    var coinCurrentPrice: Double {
        currentPrice ?? 0
    }
    
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * coinCurrentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable, Hashable {
    let price: [Double]?
}
