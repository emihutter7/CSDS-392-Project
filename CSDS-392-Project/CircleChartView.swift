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

    private let chartColors: [Color] = [
        Color(red: 0.75, green: 0.55, blue: 0.60),
        Color(red: 0.55, green: 0.43, blue: 0.35),
        Color(red: 0.88, green: 0.80, blue: 0.81),
        Color(red: 0.83, green: 0.70, blue: 0.73),
        Color(red: 0.91, green: 0.86, blue: 0.84)
    ]

    private var total: Double {
        values.reduce(0, +)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(red: 0.93, green: 0.89, blue: 0.88), lineWidth: lineWidth)

            if total > 0 {
                let angles = normalizedSegments(values: values)

                ForEach(Array(angles.enumerated()), id: \.offset) { index, segment in
                    Circle()
                        .trim(from: segment.start, to: segment.end)
                        .stroke(
                            chartColors[index % chartColors.count],
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
        .padding()
        .background(Color(red: 0.97, green: 0.95, blue: 0.94))
}
