//
//  MarketItemViewModel.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Foundation
import SwiftUI

struct MarketItemViewModel: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    let price: Double
    let priceChangePercentage: Double
    let image: URL

    private static let hugePricePercentageMovement: Double = 19
}

extension MarketItemViewModel {
    var rankText: String {
        " #\(rank) "
    }

    var priceText: String {
        price > 10
            ? "\(Int(price)) CZK"
            : String(format: "%.1f", price) + " CZK"
    }

    var priceChangeText: String {
        let priceChangeFormatted = String(format: "%.1f", priceChangePercentage) + "%"
        if priceChangePercentage > Self.hugePricePercentageMovement {
            return "🚀 \(priceChangeFormatted)"
        } else if priceChangePercentage < -Self.hugePricePercentageMovement {
            return "📉 \(priceChangeFormatted)"
        }
        return priceChangeFormatted
    }

    var priceChangeColor: Color {
        priceChangePercentage >= 0 ? .green : .red
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
