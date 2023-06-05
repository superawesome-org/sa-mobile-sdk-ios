//
//  PerformanceRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 02/06/2023.
//

protocol PerformanceRepositoryType {
    func sendCloseButtonPressTime(value: Int64, completion: OnResult<Void>?)
}

class PerformanceRepository: PerformanceRepositoryType {
    private let dataSource: AwesomeAdsApiDataSourceType
    private let logger: LoggerType

    init(dataSource: AwesomeAdsApiDataSourceType, logger: LoggerType) {
        self.dataSource = dataSource
        self.logger = logger
    }
    
    func sendCloseButtonPressTime(value: Int64, completion: OnResult<Void>?) {
        let metric = PerformanceMetric(value: value,
                                       metricName: .closeButtonPressTime,
                                       metricType: .gauge)
        
        dataSource.performance(metric: metric, completion: completion)
    }
}
