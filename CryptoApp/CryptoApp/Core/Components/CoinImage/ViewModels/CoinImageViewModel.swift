//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import Foundation
import Combine
import SwiftUI

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let coin: CoinModel
    private let coinImageService: ImageFetcherService
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinImageService = ImageFetcherService(urlString: coin.image, imageName: coin.id)
        self.addSubsriber()
        self.isLoading = true
    }
    
    private func addSubsriber() {
        coinImageService.$image
            .sink(receiveCompletion: { [weak self] _ in
                guard let self else { return }
                self.isLoading = false
            }, receiveValue: { [weak self] returnedImage in
                guard let self else { return }
                self.image = returnedImage
            })
            .store(in: &cancellables)
        
    }
}
