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
        HStack(spacing: 12) {
            // icon
            AsyncImage(url: model.image)
                .cornerRadius(20)
                .frame(width: 35, height: 35)

            // name, rank, symbol
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name)
                    .font(.body)
                    .fontWeight(.bold)

                HStack(spacing: 6) {
                    Text(model.rankText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(2)
                        .background(Color(.systemFill))
                        .cornerRadius(4)

                    Text(model.symbol)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }

            Spacer()

            // price, percentage change
            VStack(alignment: .trailing, spacing: 2) {
                Text(model.priceText)
                    .font(.body)
                    .fontWeight(.bold)

                Text(model.priceChangeText)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(model.priceChangeColor)
            }
        }
    }
}

struct MarketItemView_Previews: PreviewProvider {
    static var previews: some View {
        MarketItemView(model: MarketItemViewModel.samplePreview())
        MarketItemView(model: MarketItemViewModel.samplePreview())
            .preferredColorScheme(.dark)
    }
}

