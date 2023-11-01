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
}

struct ColorTheme {
    let tint = Color("AccentColor")
    let background = Color("backgroundColor")
    let red = Color("red")
    let green = Color("green")
    let secondaryText = Color("secondaryTextColor")
}
