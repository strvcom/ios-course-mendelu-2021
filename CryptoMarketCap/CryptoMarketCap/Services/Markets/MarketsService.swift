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

    static let shared = MarketsService()

    init() {

    }
}

extension MarketsService: MarketsServicing {
    func markets() -> AnyPublisher<[MarketItem], Error> {
        CoingeckoAPI.markets()
    }

    func marketChart(marketId: String) -> AnyPublisher<[ChartViewModel.Value], Error> {
        CoingeckoAPI.marketChart(marketId: marketId)
    }
}
