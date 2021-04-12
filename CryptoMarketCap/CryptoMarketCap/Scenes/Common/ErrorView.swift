//
//  ErrorView.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import SwiftUI

struct ErrorView<Content: View>: View {
    let banner: String
    let title: String
    let message: String?
    let content: () -> Content

    var body: some View {
        VStack(spacing: 16) {
            Text(banner)
                .font(.largeTitle)

            Text(title)
                .font(.title2)

            if let message = message {
                Text(message)
                    .padding([.leading, .trailing], 20)
                    .multilineTextAlignment(.center)
            }
            content()
        }
    }

    init(banner: String = "😭", title: String = "Ooops", message: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.banner = banner
        self.title = title
        self.message = message
        self.content = content
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            banner: "🤔",
            title: "Ooops",
            message: "An error occured, please try again",
            content: {
                Button("Retry") {
                    print("TODO")
                }
            }
        )
        ErrorView(
            banner: "🤔",
            title: "Ooops",
            message: "An error occured, please try again",
            content: {
                Button("Retry") {
                    print("TODO")
                }
            }
        ).preferredColorScheme(.dark)
    }
}
