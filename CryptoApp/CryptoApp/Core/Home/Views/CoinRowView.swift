//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 30.10.2023.
//

import SwiftUI

struct CoinRowView: View {
    @EnvironmentObject private var vmFactory: ViewModelFactory
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            
            Spacer()
            
            if showHoldingsColumn {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        .environmentObject(dev.viewModelFactory)
        
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(vm: vmFactory.makeCoinImageViewModel(forCoin: coin))
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.tint)
                .padding(.leading, 6)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals()
            )
            .fontWeight(.bold)
            
            
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.tint)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.coinCurrentPrice
                .asCurrencyWith6Decimals()
            )
            .fontWeight(.bold)
            .foregroundColor(Color.theme.tint)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .fontWeight(.semibold)
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) > 0 ? Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
