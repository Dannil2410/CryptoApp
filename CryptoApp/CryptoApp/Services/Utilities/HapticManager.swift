//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 01.11.2023.
//

import Foundation
import SwiftUI

final class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
