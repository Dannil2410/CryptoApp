//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import Foundation
import SwiftUI

final class LocalFileManager {
    static let shared = LocalFileManager()
    
    private init() {}
    
    func saveImage(_ image: UIImage, imageName: String, folderName: String) {
        
        // create folder
        createFolderIfNeeded(folderName: folderName)

        // get path for image
        guard
            let data = image.pngData(),
            let url = getUrlForImage(name: imageName, folderName: folderName) else {
            return
        }
        
        // save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. Image name: \(imageName). \(error.localizedDescription)")
        }
    }
    
    func getImage(name: String, folderName: String) -> UIImage? {
        guard
            let url = getUrlForImage(name: name, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path()) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path())
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getUrlForFolder(name: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating folder for images. Folder name: \(folderName). \(error.localizedDescription)")
            }
        }
    }
    
    private func getUrlForFolder(name: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            return nil
        }
        return url.appending(component: name)
    }
    
    private func getUrlForImage(name: String, folderName: String) -> URL? {
        guard let folderUrl = getUrlForFolder(name: folderName) else { return nil }
        return folderUrl.appending(component: name + ".png")
    }
}
