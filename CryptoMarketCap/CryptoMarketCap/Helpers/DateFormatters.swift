//
//  DateFormatters.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 13.04.2021.
//

import Foundation

enum DateFormatters {
    static var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
