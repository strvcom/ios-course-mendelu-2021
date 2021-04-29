//
//  NetworkMock.swift
//  CryptoMarketCapTests
//
//  Created by Filip Haškovec on 29.04.2021.
//

import Combine
import Foundation
@testable import CryptoMarketCap

class NetworkMock: Networking {
    func perform<T>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<NetworkResponse<T>, Error> where T : Decodable {
//            print(T.self is CoingeckoAPI.CoingeckoMarket)
//            print(T.Type == CoingeckoAPI.CoingeckoMarket.Type)
//            print(T.self is CoingeckoAPI.CoingeckoMarket)
        guard T.self == [CoingeckoAPI.CoingeckoMarket].self else {
            return Empty(outputType: NetworkResponse<T>.self,
                         failureType: Error.self)
                .eraseToAnyPublisher()
        }

        let mockedUrlResponse = URLResponse()
        return Just(NetworkResponse<T>(value: mockNetworkMarkets as! T, response: mockedUrlResponse))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }


}

extension NetworkMock {
    var mockNetworkMarkets: [CoingeckoAPI.CoingeckoMarket] {
        [
            CoingeckoAPI.CoingeckoMarket(id: "bitcoin",
                       name: "Bitcoin",
                       symbol: "btc",
                       image:"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
                       currentPrice: 1152498,
                       marketCap: 21545029536768,
                       marketCapRank: 1,
                       priceChangePercentage24h: -1.39861),
            CoingeckoAPI.CoingeckoMarket(id: "ethereum",
                       name: "Ethereum",
                       symbol: "eth",
                       image: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
                       currentPrice: 58070,
                       marketCap: 6714374876849,
                       marketCapRank: 2,
                       priceChangePercentage24h: 3.34647)
        ]
    }

    static var mockMarkets: [MarketItem] {
        [
            MarketItem(id: "bitcoin",
                       name: "Bitcoin",
                       symbol: "btc",
                       imageUrl: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")!,
                       currentPrice: 1152498,
                       marketCap: 21545029536768,
                       marketCapRank: 1,
                       priceChangePercentage24h: -1.39861),
            MarketItem(id: "ethereum",
                       name: "Ethereum",
                       symbol: "eth",
                       imageUrl: URL(string: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880")!,
                       currentPrice: 58070,
                       marketCap: 6714374876849,
                       marketCapRank: 2,
                       priceChangePercentage24h: 3.34647)
        ]
    }
}
