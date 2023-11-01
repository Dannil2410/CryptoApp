//
//  ImageFetcherService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import Foundation
import Combine
import SwiftUI

final class ImageFetcherService {
    
    @Published var image: UIImage? = nil
    private var coinImageSubscription: AnyCancellable?
    private let session = URLSession.shared
    private let fileManager = LocalFileManager.shared
    private let coinImagesFolderName = "coinImages"
    
    init(urlString: String, imageName: String) {
        
        getCoinImage(urlString: urlString, imageName: imageName)
    }
    
    private func getCoinImage(urlString: String, imageName: String) {
        if let image = LocalFileManager.shared.getImage(name: imageName, folderName: coinImagesFolderName) {
            self.image = image
            return
        }
        downloadCoinImage(urlString: urlString, imageName: imageName)
    }
    
    private func downloadCoinImage(urlString: String, imageName: String) {
        guard let url = URL(string: urlString) else { return }
        
        coinImageSubscription = session.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] returnedImage in
                guard
                    let self,
                    let returnedImage = returnedImage else {
                    return
                }
                self.image = returnedImage
                self.fileManager.saveImage(returnedImage, imageName: imageName, folderName: coinImagesFolderName)
                self.coinImageSubscription?.cancel()
            })
    }
}
