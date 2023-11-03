//
//  Date+Extensions.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import Foundation

extension Date {
    
    private var shortFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    init(coinGeckoString: String) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = df.date(from: coinGeckoString) ?? .now
        self.init(timeInterval: 0, since: date)
    }

    func asShortFormat() -> String {
        shortFormatter.string(from: self)
    }
}
