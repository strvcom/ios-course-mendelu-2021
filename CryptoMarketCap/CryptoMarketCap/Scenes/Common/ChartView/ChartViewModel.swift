//
//  ChartViewModel.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 13.04.2021.
//

import Foundation

struct ChartViewModel: Identifiable {
    struct Value {
        let date: Date
        let value: Double
    }

    let id = UUID()

    let values: [Value]
    let minimumValue: Double
    let maximumValue: Double

    init(values: [Value], minimumValue: Double, maximumValue: Double) {
        self.values = values
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.difference = maximumValue - minimumValue
        self.lastDate = values.last!.date
        self.currentPrice = values.last!.value
        let percentage = (values.last!.value / values.first!.value * 100) - 100
        self.priceDifferencePercentage = "\(String(format: "%.1f", percentage)) %"
        self.priceDifferenceIsPositive = percentage > 0
    }

    /// Difference between maximum & minimum value
    let difference: Double
    let lastDate: Date
    let currentPrice: Double
    let priceDifferencePercentage: String
    let priceDifferenceIsPositive: Bool
}
