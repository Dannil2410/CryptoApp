//
//  Color+Extensions.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let tint = Color("AccentColor")
    let background = Color("BackgroundColor")
    let red = Color("Red")
    let green = Color("Green")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let background = Color("LaunchBackgroundColor")
    let tint = Color("LaunchAccentColor")
}
