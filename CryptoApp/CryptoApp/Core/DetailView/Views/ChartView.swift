//
//  ChartView.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 03.11.2023.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let strokeColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.strokeColor = priceChange >= 0 ? Color.theme.green : Color.theme.red
        
        self.endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(alignment: .leading) {
                    chartYAxis
                        .padding(.horizontal, 4)
                }
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            withAnimation(.linear(duration: 2.0).delay(0.2)) {
                percentage = 1.0
            }
        }
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index+1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - (data[index] - minY) / yAxis) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(
                strokeColor,
                style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: strokeColor, radius: 10, x: 0, y: 10)
            .shadow(color: strokeColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: strokeColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: strokeColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortFormat())
            Spacer()
            Text(endingDate.asShortFormat())
            
        }
    }
}
