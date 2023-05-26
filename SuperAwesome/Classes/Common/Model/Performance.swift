//
//  Performance.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 26/05/2023.
//

struct PerformanceMetric: Codable {
    let value: Int
    let metricName: PerformanceMetricName
    let metricType: PerformanceMetricType
    
    func build() -> [String: Any] {
        [
            "value": value,
            "metricName": metricName.rawValue,
            "metricType": metricType.rawValue
        ]
    }
}

enum PerformanceMetricName: String, Codable {
    case gauge
    case increment
    case decrementBy
    case decrement
    case histogram
    case incrementBy
    case timing
}

enum PerformanceMetricType: String, Codable {
    case closeButtonPressTime = "sa.ad.sdk.close.button.press.time"
    case dwellTime = "sa.ad.sdk.dwell.time"
    case loadTime = "sa.ad.sdk.performance.load.time"
    case renderTime = "sa.ad.sdk.performance.render.time"
}
