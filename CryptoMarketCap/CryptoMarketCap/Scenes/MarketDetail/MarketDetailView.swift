//
//  MarketDetailView.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 13.04.2021.
//

import SwiftUI

struct MarketDetailView: View {
    @StateObject var store: MarketDetailStore

    // MARK: body
    var body: some View {
        Group {
            switch store.chartState {
            case .initial:
                EmptyView()

            case .loading:
                ProgressView()

            case .ready(let model):
                ScrollView {
                    ChartView(model: model)
                        .frame(height: 340)
                }
                .padding(.horizontal)

            case .failed(let error):
                ErrorView(
                    message: error.localizedDescription,
                    buttonTitle: "Retry",
                    buttonAction: {
                        store.loadData()
                    }
                )
            }
        }
        .onAppear {
            store.loadData()
        }
        // MARK: Navigation title
        .navigationBarTitle("#\(store.marketItem.marketCapRank) \(store.marketItem.name)", displayMode: .inline)
    }
}
