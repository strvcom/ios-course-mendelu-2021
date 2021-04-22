//
//  MarketsView.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import SwiftUI

struct MarketsView: View {
    // MARK: Store
    @StateObject var store = MarketsStore()

    // MARK: body
    var body: some View {
        ZStack {
            switch store.state {
            case .initial:
                EmptyView()

            case .loading:
                ProgressView()

            case .ready(let markets):
                List(markets, id: \.id) { marketItem in
                    NavigationLink(destination: MarketDetailView(store: MarketDetailStore(marketItem: marketItem))) {
                        MarketItemView(model: marketItem.marketItemModel)
                    }
                }
                .environment(\.defaultMinListRowHeight, 65)

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
            // Load data on appear
            store.loadData()
        }
        // MARK: Navigation title & items
        .navigationTitle("Markets")
    }
}
