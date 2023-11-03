//
//  ImageFetcherService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import Foundation
import Combine
import SwiftUI

protocol ImageFetcher {
    var imagePublisher: Published<UIImage?>.Publisher { get }
    func getCoinImage(urlString: String, imageName: String)
}

final class ImageFetcherService: ImageFetcher {
    @Published private var image: UIImage? = nil
    private var coinImageSubscription: AnyCancellable?
    private let session = URLSession.shared
    private let fileManager: LocalFileManagerProtocol
    private let coinImagesFolderName = "coinImages"
    
    var imagePublisher: Published<UIImage?>.Publisher {
        $image
    }
    
    init(fileManager: LocalFileManagerProtocol) {
        self.fileManager = fileManager
    }
    
    func getCoinImage(urlString: String, imageName: String) {
        if let image = fileManager.getImage(name: imageName, folderName: coinImagesFolderName) {
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
