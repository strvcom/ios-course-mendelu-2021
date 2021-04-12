//
//  Market.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Foundation

struct Market: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    let marketCap: Int
    let marketCapRank: Int
    let priceChangePercentage24h: Double
}

// MARK: marketItemModel
extension Market {
    var marketItemModel: MarketItemViewModel? {
        guard let imageUrl = URL(string: image) else {
            print("Ooops. Image url decoding fail.")
            return nil
        }
        return MarketItemViewModel(
            id: id,
            name: name,
            symbol: symbol.uppercased(),
            rank: marketCapRank,
            price: currentPrice,
            priceChangePercentage: priceChangePercentage24h,
            image: imageUrl
        )
    }
}
