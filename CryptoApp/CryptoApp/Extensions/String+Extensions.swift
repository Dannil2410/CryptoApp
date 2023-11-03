//
//  String+Extensions.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
