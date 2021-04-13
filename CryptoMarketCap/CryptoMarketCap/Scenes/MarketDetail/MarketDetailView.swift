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

//                        // additional info
//                        switch store.additionalInfoState {
//                        case .ready(let model):
//                            additionalInfo(model)
//                        default:
//                            EmptyView()
//                        }
                }
                .padding(.horizontal)

            case .failed(let error):
                ErrorView(
                    message: error.localizedDescription,
                    content: {
                        Button("Retry") {
                            store.loadData()
                        }
                    }
                )
            }
        }
        .onAppear {
            store.loadData()
        }
        // MARK: Navigation title
        .navigationBarTitle("#\(store.market.marketCapRank) \(store.market.name)", displayMode: .inline)
    }

//    // MARK: additionalInfo
//    private func additionalInfo(_ additionaInfo: MarketDetailViewModel.AdditionalInfo) -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Additional information")
//                .font(.title3)
//                .bold()
//                .foregroundColor(Color(.label))
//
//            LazyVGrid(
//                columns: [
//                    // Two items in a row
//                    GridItem(.flexible()), GridItem(.flexible())
//                ],
//                alignment: .leading,
//                spacing: 10,
//                content: {
//                    ForEach(additionaInfo.items) { item in
//                        VStack(alignment: .leading) {
//                            Text(item.title)
//                                .fontWeight(.medium)
//                                .foregroundColor(Color(.secondaryLabel))
//
//                            Text(item.value)
//                                .fontWeight(.medium)
//                                .foregroundColor(Color(.label))
//                        }
//                    }
//                }
//            )
//
//            if let websiteUrl = additionaInfo.websiteLink {
//                HStack {
//                    Text("Website")
//                        .fontWeight(.medium)
//                        .foregroundColor(Color(.secondaryLabel))
//
//                    Link(websiteUrl.relativeString, destination: websiteUrl)
//                        .foregroundColor(Color(.tertiaryLabel))
//
//                    Spacer()
//                }
//            }
//
//        }
//    }
}
