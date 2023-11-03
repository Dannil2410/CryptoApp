//
//  HomeViewDataFetcherService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine
import SwiftUI

protocol HomeViewDataFetcher {
    var allCoinsPublisher: AnyPublisher<[CoinModel], Never> { get }
    var globalDataPublisher: AnyPublisher<GlobalData, Never> { get }
    func getCoinsMarkets()
    func getGlobalData()
}

final class HomeViewDataFetcherService: HomeViewDataFetcher {
    
    private var allCoinsSubject = PassthroughSubject<[CoinModel], Never>()
    private var globalDataSubject = PassthroughSubject<GlobalData, Never>()
    private var coinSubscription: AnyCancellable?
    private var globalDataSubscription: AnyCancellable?
    private let networkManager: Networking
    
    var allCoinsPublisher: AnyPublisher<[CoinModel], Never> {
        allCoinsSubject
            .eraseToAnyPublisher()
    }
    
    var globalDataPublisher: AnyPublisher<GlobalData, Never> {
        globalDataSubject
            .eraseToAnyPublisher()
    }
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func getCoinsMarkets() {
        guard let url = CoinGeckoAPI.getCoinsMarketsURL() else { return }
        
        coinSubscription = networkManager.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completion,
                receiveValue: { [weak self] returnedCoins in
                    guard let self else { return }
                    self.allCoinsSubject.send(returnedCoins)
                    self.coinSubscription?.cancel()
                })
    }
    
    func getGlobalData() {
        guard let url = CoinGeckoAPI.getGlobalDataURL() else { return }
        
        globalDataSubscription = networkManager.request(for: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completion,
                receiveValue: { [weak self] returnedGlobalData in
                    guard let self else { return }
                    self.globalDataSubject.send(returnedGlobalData)
                    self.globalDataSubscription?.cancel()
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
