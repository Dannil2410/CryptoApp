//
//  NetworkError.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case decodingError
    case genericError(String)
    case invalidResponseCode(Int)
    
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "[🔥] Bad response for url"
        case .decodingError:
            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
        case .genericError(let message):
            return message
        case .invalidResponseCode(let responseCode):
            return "Invalid response code encountered from the server. Expected 200, received \(responseCode)"
        }
    }
}
