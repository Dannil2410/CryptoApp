//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine

struct NetworkManager {
    private static let session = URLSession.shared
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func request<T>(for url: URL) -> AnyPublisher<T, Error> where T : Decodable {
        return NetworkManager.session.dataTaskPublisher(for: url)
            .tryMap { try NetworkManager.handleUrlResponse(data: $0.data, response: $0.response) }
//            .tryMap { (data, _) in
//                let json = try JSONSerialization.jsonObject(with: data)
//                print(json)
//                return data
//            }
            .decode(type: T.self, decoder: NetworkManager.decoder)
            .mapError { NetworkManager.proccessError($0) }
            .eraseToAnyPublisher()
    }
    
    static func handleUrlResponse(data: Data, response: URLResponse) throws -> Data {
        if let response = response as? HTTPURLResponse {
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.invalidResponseCode(response.statusCode)
            }
        }
        return data
    }
    
    static func proccessError(_ error: Error) -> NetworkError {
        if let _ = error as? DecodingError {
            return NetworkError.decodingError
        }
        return NetworkError.genericError(error.localizedDescription)
    }
    
    static func completion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Fetch data successfully finished")
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}
