//
//  MarketItemViewModel.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Foundation

struct MarketItemViewModel: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    /// Already formatted price with currency symbol
    let price: Double
    let priceChangePercentage: Double
    let image: URL
}

extension MarketItemViewModel {
    var priceHumanReadable: String {
        price > 10
            ? "\(Int(price)) CZK"
            : String(format: "%.1f", price) + " CZK"
    }

    var priceChangePercentageHumanReadable: String {
        let priceChangeFormatted = String(format: "%.1f", priceChangePercentage) + "%"
        if priceChangePercentage > 19 {
            return "🚀 \(priceChangeFormatted)"
        } else if priceChangePercentage < -19 {
            return "📉 \(priceChangeFormatted)"
        }
        return priceChangeFormatted
    }

    var priceChangePercentageIsPositive: Bool {
        priceChangePercentage >= 0
    }
}

extension MarketItemViewModel {
    static func samplePreview() -> MarketItemViewModel {
        return MarketItemViewModel.init(
            id: UUID().uuidString,
            name: "Bitcoin",
            symbol: "BTC",
            rank: 1,
            price: 100000,
            priceChangePercentage: 0.0,
            image: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")!
        )
    }
}
