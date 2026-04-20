//
//  CircleChartView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI

struct CircleChartView: View {
    let values: [Double]
    let lineWidth: CGFloat

    private var total: Double {
        values.reduce(0, +)
    }

    var body: some View {
        ZStack {
            if total == 0 {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.25), style: StrokeStyle(lineWidth: lineWidth))
            } else {
                let angles = normalizedSegments(values: values)

                ForEach(Array(angles.enumerated()), id: \.offset) { index, segment in
                    Circle()
                        .trim(from: segment.start, to: segment.end)
                        .stroke(
                            Color.black,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                        )
                        .rotationEffect(.degrees(-90))
                }
            }
        }
    }

    private func normalizedSegments(values: [Double]) -> [(start: Double, end: Double)] {
        let total = values.reduce(0, +)
        guard total > 0 else { return [] }

        var current: Double = 0
        var result: [(start: Double, end: Double)] = []

        for value in values {
            let fraction = value / total
            let next = current + fraction
            result.append((start: current, end: next))
            current = next
        }

        return result
    }
}

#Preview {
    CircleChartView(values: [100, 200, 300, 400, 500], lineWidth: 10)
}
