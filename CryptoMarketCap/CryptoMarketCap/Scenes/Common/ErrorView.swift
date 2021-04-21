//
//  ErrorView.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import SwiftUI

struct ErrorView: View {
    let banner: String
    let title: String
    let message: String?
    let buttonTitle: String
    let buttonAction: (() -> Void)

    var body: some View {
        VStack(spacing: 16) {
            Text(banner)
                .font(.largeTitle)

            Text(title)
                .font(.title2)

            if let message = message {
                Text(message)
                    .padding([.horizontal], 20)
                    .multilineTextAlignment(.center)
            }

            Button(buttonTitle) {
                buttonAction()
            }
        }
    }

    init(banner: String = "😭", title: String = "Ooops", message: String? = nil, buttonTitle: String, buttonAction: @escaping (() -> Void)) {
        self.banner = banner
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            banner: "🤔",
            title: "Ooops",
            message: "An error occured, please try again",
            buttonTitle: "Retry",
            buttonAction: {
                print("Retry tapped")
            }
        )
        ErrorView(
            banner: "🤔",
            title: "Ooops",
            message: "An error occured, please try again",
            buttonTitle: "Retry",
            buttonAction: {
                print("Retry tapped")
            }
        ).preferredColorScheme(.dark)
    }
}
