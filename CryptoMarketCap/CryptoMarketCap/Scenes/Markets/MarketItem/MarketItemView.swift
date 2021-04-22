//
//  MarketItemView.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import SwiftUI

struct MarketItemView: View {
    let model: MarketItemViewModel

    // MARK: body
    var body: some View {
        EmptyView()

        // icon

        // name, rank, symbol

        // price, percentage change
    }
}

struct MarketItemView_Previews: PreviewProvider {
    static var previews: some View {
        MarketItemView(model: MarketItemViewModel.samplePreview())
        MarketItemView(model: MarketItemViewModel.samplePreview())
            .preferredColorScheme(.dark)
    }
}

