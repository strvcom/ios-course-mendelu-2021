//
//  MarketsService.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Combine
import Foundation

protocol MarketsServicing: AnyObject {
    func markets() -> AnyPublisher<[Market], Error>
}

final class MarketsService {

    static let shared = MarketsService()

    init() {

    }
}

extension MarketsService: MarketsServicing {
    func markets() -> AnyPublisher<[Market], Error> {
        CoingeckoAPI.markets()
    }
}
