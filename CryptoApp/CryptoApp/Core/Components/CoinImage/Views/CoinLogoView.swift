//
//  CoinLogoView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 01.11.2023.
//

import SwiftUI

struct CoinLogoView: View {
    
    @EnvironmentObject private var vmFactory: ViewModelFactory
    let coin: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(vm: vmFactory.makeCoinImageViewModel(forCoin: coin))
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.tint)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
            
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        .environmentObject(dev.viewModelFactory)
    }
}
