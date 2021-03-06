//
//  ChartViewModel.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 13.04.2021.
//

import Foundation
import SwiftUI

struct ChartViewModel: Identifiable {
    struct Value {
        let date: Date
        let value: Double
    }

    let id = UUID()
    let values: [Value]
    let minimumValue: Double
    let maximumValue: Double

    init?(values: [Value], minimumValue: Double, maximumValue: Double) {
        guard
            values.isEmpty == false,
            let firstValue = values.first,
            let lastValue = values.last
        else {
            return nil
        }

        self.values = values
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.difference = maximumValue - minimumValue
        self.lastDate = lastValue.date
        self.currentPrice = lastValue.value
        let percentage = ((lastValue.value - firstValue.value) / firstValue.value * 100)
        self.priceDifferencePercentageText = "\(String(format: "%.1f", percentage)) %"
        self.priceDifferenceIsPositive = percentage > 0
    }

    let priceDifferencePercentageText: String
    /// Difference between maximum & minimum value
    private let difference: Double
    private let lastDate: Date
    private let currentPrice: Double
    private let priceDifferenceIsPositive: Bool
}

extension ChartViewModel {
    var currentPriceText: String {
        String(format: "%.1f", currentPrice) + " CZK"
    }

    var currentDateText: String {
        DateFormatters.shortDateFormatter.string(from: (lastDate))
    }

    var priceDifferenceColor: Color {
        priceDifferenceIsPositive ? .green : .red
    }
}
