//
//  CoingeckoAPI.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Combine
import Foundation

enum CoingeckoAPI {
    static let client = NetworkClient()

    private static let base: String = "https://api.coingecko.com/api/v3"
}

// MARK: - Endpoints
extension CoingeckoAPI {
    static func markets() -> AnyPublisher<[Market], Error> {
        let url = buildUrl(with: "/coins/markets?vs_currency=czk&order=market_cap_desc&per_page=100&page=1&sparkline=false")
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        let request: AnyPublisher<[CoingeckoMarket], Error> = run(urlRequest)
        return request
            .map { $0.map(\.market) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Helpers
extension CoingeckoAPI {
    private static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        client.perform(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    private static func buildUrl(with path: String) -> URL {
        let stringUrl = base + path
        return URL(string: stringUrl)!
    }
}

// MARK: - Models
extension CoingeckoAPI {
    struct PriceItems: Decodable {
        let eur: Double
        let usd: Double
    }

    // MARK: Market cap
    struct CoingeckoTotalMarket: Decodable {
        struct Data: Decodable {
            private enum CodingKeys: String, CodingKey {
                case totalMarketCap = "total_market_cap"
                case totalMarketCap24hChange = "market_cap_change_percentage_24h_usd"
            }

            let totalMarketCap: PriceItems
            let totalMarketCap24hChange: Double
        }

        let data: Data
    }

    // MARK: Market
    struct CoingeckoMarket: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case symbol = "symbol"
            case image = "image"
            case currentPrice = "current_price"
            case marketCap = "market_cap"
            case marketCapRank = "market_cap_rank"
            case priceChangePercentage24h = "price_change_percentage_24h"
        }


        let id: String
        let name: String
        let symbol: String
        let image: String
        let currentPrice: Double
        let marketCap: Int
        let marketCapRank: Int
        let priceChangePercentage24h: Double?

        var market: Market {
            Market(
                id: id,
                name: name,
                symbol: symbol,
                image: image,
                currentPrice: currentPrice,
                marketCap: marketCap,
                marketCapRank: marketCapRank,
                priceChangePercentage24h: priceChangePercentage24h ?? 0
            )
        }
    }
}
