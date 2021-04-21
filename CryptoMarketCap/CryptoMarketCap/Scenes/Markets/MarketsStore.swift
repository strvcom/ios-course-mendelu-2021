//
//  MarketsStore.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Combine
import SwiftUI

final class MarketsStore: ObservableObject {
    // State
    enum State {
        case initial
        case loading
        case ready(markets: [MarketItem])
        case failed(error: Error)
    }

    // Dependencies
    private let marketsService: MarketsServicing = MarketsService.shared

    // Public
    @Published private(set) var state = State.initial

    // Private
    private let refreshDataSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init() {
        refreshDataSubject
            .handleEvents(receiveOutput: { [weak self] in
                guard let self = self else { return }
                switch self.state {
                case .initial, .failed:
                    // If state is not loaded yet, we want to show loading indicator.
                    self.state = .loading
                default:
                    return
                }
            })
            .compactMap { [weak self] _ -> AnyPublisher<State, Never>? in
                self?.marketsService.markets()
                    // Map data to state
                    .map { markets -> State in
                        State.ready(markets: markets)
                    }
                    // Map error to failed state
                    .catch { error in
                        Just(State.failed(error: error))
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }

    func loadData() {
        refreshDataSubject.send()
    }
}
