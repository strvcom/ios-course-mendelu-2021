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

    // Dependencies
    private let marketsService: MarketsServicing = MarketsService.shared

    @Published private(set) var chartState = ChartState.initial
//    typealias AdditionalInfoStateType = ViewModelState<MarketDetailViewModel.AdditionalInfo>
//    @Published private(set) var additionalInfoState = AdditionalInfoStateType.initial

    let marketItem: MarketItem

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
                            let maximum = values.map(\.value).max()
                        else {
                            return ChartState.failed(error: UnknownChartError())
                        }

                        let chartViewModel = ChartViewModel(values: values, minimumValue: minumum, maximumValue: maximum)
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

//        // Additional info
//        refreshDataSubject.eraseToAnyPublisher()
//            .filter { [weak self] in
//                guard let self = self else { return false }
//                switch self.additionalInfoState {
//                case .ready:
//                    return false
//                default:
//                    return true
//                }
//            }
//            .compactMap { [weak self] _ -> AnyPublisher<AdditionalInfoStateType, Never>? in
//                guard let self = self else { return nil }
//
//                return self.marketsService.marketDetail(market: self.market)
//                    // Ready state
//                    .map { value -> AdditionalInfoStateType in
//                        AdditionalInfoStateType.ready(
//                            value: MarketDetailViewModel.AdditionalInfo(
//                                marketCap: value.marketCap,
//                                ath: value.ath,
//                                athChangePercentage: value.athChangePercentage,
//                                totalVolume: value.totalVolume,
//                                genesisDate: value.genesisDate,
//                                website: value.website
//                            )
//                        )
//                    }
//                    // Failed state
//                    .catch { error in Just(AdditionalInfoStateType.failed(error: error)) }
//                    .eraseToAnyPublisher()
//            }
//            .switchToLatest()
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    self?.loadingNewChart = false
//                    self?.additionalInfoState = .failed(error: error)
//                case .finished: return
//                }
//            }, receiveValue: { [weak self] state in
//                self?.loadingNewChart = false
//                self?.additionalInfoState = state
//            })
//            .store(in: &cancellables)
    }

    func loadData() {
        refreshDataSubject.send()
    }
}
