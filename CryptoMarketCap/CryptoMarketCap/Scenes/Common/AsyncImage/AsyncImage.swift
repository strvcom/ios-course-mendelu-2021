//
//  AsyncImage.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader

    init(
        url: URL
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                // Loaded image
                Image(uiImage: image).resizable()
            } else {
                // Placeholder
                Color(.systemGray)
            }
        }
    }
}
