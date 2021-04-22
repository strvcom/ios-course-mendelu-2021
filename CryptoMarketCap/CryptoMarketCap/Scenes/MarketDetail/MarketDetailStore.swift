//
//  MarketDetailStore.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 13.04.2021.
//

import Combine
import SwiftUI

struct UnknownChartError: Error { }

final class MarketDetailStore: ObservableObject {
    // ChartState
    enum ChartState {
        case initial
        case loading
        case ready(chart: ChartViewModel)
        case failed(error: Error)
    }

    // Public
    let marketItem: MarketItem

    // Dependencies
    private let marketsService: MarketsServicing = MarketsService.shared

    @Published private(set) var chartState = ChartState.initial

    // Private
    private let refreshDataSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(marketItem: MarketItem) {
        self.marketItem = marketItem

        refreshDataSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else { return }

                switch self.chartState {
                case .initial, .loading, .failed:
                    self.chartState = .loading
                case .ready:
                    break
                }
            })
            .compactMap { [weak self] _ -> AnyPublisher<ChartState, Never>? in
                guard let self = self else { return nil }
                return self.marketsService.marketChart(marketId: self.marketItem.id)
                    // Ready state
                    .map { values -> ChartState in
                        guard
                            let minumum = values.map(\.value).min(),
                            let maximum = values.map(\.value).max(),
                            let chartViewModel = ChartViewModel(values: values, minimumValue: minumum, maximumValue: maximum)
                        else {
                            return ChartState.failed(error: UnknownChartError())
                        }
                        return ChartState.ready(chart: chartViewModel)
                    }
                    // Failed state
                    .catch { error in Just(ChartState.failed(error: error)) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [weak self] state in
                self?.chartState = state
            }
            .store(in: &cancellables)
    }

    func loadData() {
        refreshDataSubject.send()
    }
}
