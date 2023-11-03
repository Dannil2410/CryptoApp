//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject private var vm: CoinImageViewModel
    
    init(vm: CoinImageViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(vm: ViewModelFactory().makeCoinImageViewModel(forCoin: dev.coin) )
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
