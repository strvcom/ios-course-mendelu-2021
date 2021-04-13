//
//  ChartView.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 13.04.2021.
//

import SwiftUI

struct ChartView: View {
    let model: ChartViewModel

    @State private var selectedValue: ChartViewModel.Value?
    @State private var selectedPositionX: CGFloat?

    init(model: ChartViewModel) {
        self.model = model
    }

    // MARK: body
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                // Current price
                VStack(alignment: .leading) {
                    Text(String(format: "%.1f", model.currentPrice))
                        .font(.title2)
                        .bold()

                    Text("\(DateFormatters.shortDateFormatter.string(from: (model.lastDate)))")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color(.secondaryLabel))
                }

                Spacer()

                // Price difference percentage
                Text(model.priceDifferencePercentage)
                    .font(.headline)
                    .foregroundColor(Color(model.priceDifferenceIsPositive ? .systemGreen : .systemRed))
                    .padding(4)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(4)
            }
            .padding(.top)

            // Chart
            chart()
        }
    }

    // MARK: chart
    private func chart() -> some View {
        GeometryReader { geometry in
            Path.lineChart(
                points: model.values.map(\.value),
                step: CGPoint(x: stepWidth(totalWidth: geometry.size.width), y: stepHeight(totalHeight: geometry.size.height))
            )
            .stroke(
                Color(model.priceDifferenceIsPositive ? .systemGreen : .systemRed),
                style: StrokeStyle(lineWidth: 2, lineJoin: .round)
            )
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .drawingGroup()
        }
    }

    // MARK: Helpers
    private func stepWidth(totalWidth: CGFloat) -> CGFloat {
        totalWidth / CGFloat(model.values.count - 1)
    }

    private func stepHeight(totalHeight: CGFloat) -> CGFloat {
        let min: Double = model.minimumValue
        let max: Double = model.maximumValue
        if model.minimumValue != model.maximumValue {
            if (min <= 0) {
                return totalHeight / CGFloat(max - min)
            } else {
                return totalHeight / CGFloat(max - min)
            }
        }
        return 0
    }
}

extension Path {
    static func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}
