//
//  MarketsService.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Combine
import Foundation

protocol MarketsServicing: AnyObject {
    func markets() -> AnyPublisher<[MarketItem], Error>
    func marketChart(marketId: String) -> AnyPublisher<[ChartViewModel.Value], Error>
}

final class MarketsService {

    static let shared = MarketsService(coingeckoAPI: .init(client: NetworkClient()))
    let coingeckoAPI: CoingeckoAPI

    init(coingeckoAPI: CoingeckoAPI) {
        self.coingeckoAPI = coingeckoAPI
    }
}

extension MarketsService: MarketsServicing {
    func markets() -> AnyPublisher<[MarketItem], Error> {
        coingeckoAPI.markets()
    }

    func marketChart(marketId: String) -> AnyPublisher<[ChartViewModel.Value], Error> {
        coingeckoAPI.marketChart(marketId: marketId)
    }
}
