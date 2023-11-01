//
//  UIAplication+Extensions.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
