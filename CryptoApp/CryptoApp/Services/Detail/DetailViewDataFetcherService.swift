//
//  DetailViewDataFetcherService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import Foundation
import Combine
import SwiftUI

protocol DetailViewDataFetcher {
    var coinDetailsPublisher: AnyPublisher<CoinDetailModel, Never> { get }
    func getCoinsDetails(forCoinId coinId: String)
}

final class DetailViewDataFetcherService: DetailViewDataFetcher {
    
    private var coinDetailsSubject = PassthroughSubject<CoinDetailModel, Never>()
    private var coinDetailsSubscription: AnyCancellable?
    private let networkManager: Networking
    
    var coinDetailsPublisher: AnyPublisher<CoinDetailModel, Never> {
        coinDetailsSubject
            .eraseToAnyPublisher()
    }
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func getCoinsDetails(forCoinId coinId: String) {
        
        guard let url = CoinGeckoAPI.getCoinDetailsURL(forCoinId: coinId) else { return }
        
        coinDetailsSubscription = networkManager.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completion,
                receiveValue: { [weak self] returnedCoinDetailData in
                    guard let self else { return }
                    self.coinDetailsSubject.send(returnedCoinDetailData)
                    self.coinDetailsSubscription?.cancel()
                })
    }
    
    private func completion(_ completion: Subscribers.Completion<NetworkError>) {
        switch completion {
        case .finished:
            print("Fetch data successfully finished")
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}
