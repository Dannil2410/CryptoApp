//
//  HomeStatisticView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 31.10.2023.
//

import SwiftUI

struct HomeStatisticView: View {
    
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.stats) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticView(showPortfolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
