//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine

protocol Networking {
    func request<T>(for url: URL) -> AnyPublisher<T, NetworkError> where T : Decodable
    func completion(_ completion: Subscribers.Completion<NetworkError>)
}

struct NetworkManager: Networking {
    private let session = URLSession.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func request<T>(for url: URL) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return session.dataTaskPublisher(for: url)
            .tryMap { try handleUrlResponse(data: $0.data, response: $0.response) }
//            .tryMap { (data, _) in
//                let json = try JSONSerialization.jsonObject(with: data)
//                print(json)
//                return data
//            }
            .decode(type: T.self, decoder: decoder)
            .mapError { proccessError($0) }
            .eraseToAnyPublisher()
    }
    
    func completion(_ completion: Subscribers.Completion<NetworkError>) {
        switch completion {
        case .finished:
            print("Fetch data successfully finished")
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
    
    private func handleUrlResponse(data: Data, response: URLResponse) throws -> Data {
        if let response = response as? HTTPURLResponse {
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.invalidResponseCode(response.statusCode)
            }
        }
        return data
    }
    
    private func proccessError(_ error: Error) -> NetworkError {
        if let _ = error as? DecodingError {
            return NetworkError.decodingError
        }
        return NetworkError.genericError(error.localizedDescription)
    }
}
