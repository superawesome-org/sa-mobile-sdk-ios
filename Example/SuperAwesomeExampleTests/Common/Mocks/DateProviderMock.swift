//
//  DateProviderMock.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 29/10/2020.
//

@testable import SuperAwesome

struct DateProviderMock: DateProviderType {
    var monthYear: String
    func nowAsMonthYear() -> String {
        monthYear
    }
}
