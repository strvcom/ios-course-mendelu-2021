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

    private static let hostBase: String = "api.coingecko.com"
    private static let pathBase = "/api/v3"
}

// MARK: - Endpoints
extension CoingeckoAPI {
    static func markets() -> AnyPublisher<[MarketItem], Error> {
        let url = buildUrl(
            with: "/coins/markets",
            queryItems: [
                URLQueryItem(name: "vs_currency", value: "czk"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "100"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "sparkline", value: "false")
            ]
        )
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        let request: AnyPublisher<[CoingeckoMarket], Error> = run(urlRequest)
        return request
            .map { $0.compactMap(\.market) }
            .eraseToAnyPublisher()
    }

    /// - Parameters:
    ///   - marketId: `Market.id`
    /// - Returns: Get historical market data include price
    static func marketChart(marketId: String) -> AnyPublisher<[ChartViewModel.Value], Error> {
        // Load 7 day chart
        let days = 7
        let url = buildUrl(
            with: "/coins/\(marketId)/market_chart",
            queryItems: [
                URLQueryItem(name: "vs_currency", value: "czk"),
                URLQueryItem(name: "days", value: "\(days)")
            ]
        )
        let request: AnyPublisher<CoingeckoChart, Error> = run(URLRequest(url: url))
        return request
            .map(\.prices)
            .map { response in
                // API sends us the data in the format of array [[Double]]
                response.compactMap { item in
                    // item[0] is date in nanoseconds
                    // item[1] is the price value
                    guard item.count == 2 else {
                        assertionFailure("Wrong data format. Please investigate.")
                        return nil
                    }
                    let date = Date(timeIntervalSince1970: item[0] / 1000) // 1000 because of nanoseconds
                    return ChartViewModel.Value(date: date, value: item[1])
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Helpers
private extension CoingeckoAPI {
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        client.perform(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    static func buildUrl(with path: String, queryItems: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = hostBase
        components.path = pathBase + path
        components.queryItems = queryItems

        assert(components.url != nil, "URL is nil. Make sure to fix this before release.")
        return components.url!.absoluteURL
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

        var market: MarketItem? {
            guard let imageUrl = URL(string: image) else { return nil }
            return MarketItem(
                id: id,
                name: name,
                symbol: symbol,
                imageUrl: imageUrl,
                currentPrice: currentPrice,
                marketCap: marketCap,
                marketCapRank: marketCapRank,
                priceChangePercentage24h: priceChangePercentage24h ?? 0
            )
        }
    }

    // MARK: Chart
    struct CoingeckoChart: Decodable {
        let prices: [[Double]]
    }
}
