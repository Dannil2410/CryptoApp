//
//  MarketDataModel.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import Foundation

//CoinGecko API info
/*
 
 URL: https://api.coingecko.com/api/v3/global
 
 JSON response:
 {
   "data": {
     "active_cryptocurrencies": 10667,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 915,
     "total_market_cap": {
       "btc": 38419468.16664006,
       "eth": 731921001.6846364,
       "ltc": 18831654490.847763,
       "bch": 5397395740.397262,
       "bnb": 5801828870.594879,
       "eos": 2098210657991.5498,
       "xrp": 2192261088010.698,
       "xlm": 10876053921720.715,
       "link": 116703973477.90294,
       "dot": 296606476319.84393,
       "yfi": 229430391.4584693,
       "usd": 1315716876788.1106,
     },
     "total_volume": {
       "btc": 1595287.657658756,
       "eth": 30391481.092458017,
       "ltc": 781944868.4776213,
       "bch": 224115512.7605898,
       "bnb": 240908748.37109154,
       "eos": 87123787121.24966,
       "xrp": 91029033533.2061,
       "xlm": 451605277566.4837,
       "link": 4845887186.192022,
       "dot": 12315960460.524042,
       "yfi": 9526614.741203532,
       "usd": 54632377663.570366,
     },
     "market_cap_percentage": {
       "btc": 50.83184627984381,
       "eth": 16.41239532264671,
       "usdt": 6.418962482498925,
       "bnb": 2.6508664046924655,
       "xrp": 2.437886758829561,
       "usdc": 1.8910201771041975,
       "steth": 1.2027511753617819,
       "sol": 1.1496188464099009,
       "ada": 0.7845987277454323,
       "doge": 0.7427598741193998
     },
     "market_cap_change_percentage_24h_usd": -0.6528193497214689,
     "updated_at": 1698760159
   }
 }
 
 */

// MARK: - GlobalData
struct GlobalData: Decodable {
    let data: MarketDataModel?
    
    static let blankObject = GlobalData(data: nil)
}


// MARK: - MarketDataModel
struct MarketDataModel: Decodable {
    let totalMarketCap: [String: Double]
    let totalVolume: [String: Double]
    let marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: {$0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: {$0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}) {
            return "\(item.value.asPercentString())"
        }
        return ""
    }
}
