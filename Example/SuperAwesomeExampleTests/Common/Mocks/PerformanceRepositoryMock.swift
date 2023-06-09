//
//  PerformanceRepositoryMock.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 08/06/2023.
//

@testable import SuperAwesome

class PerformanceRepositoryMock: PerformanceRepositoryType {
    var response: Result<(), Error>  = Result<(), Error>.success(())
    var sendCloseButtonPressTimeCount = 0
    var sendDwellTimeCount = 0
        
    
    func sendCloseButtonPressTime(value: Int64, completion: SuperAwesome.OnResult<Void>?) {
        completion?(response)
        sendCloseButtonPressTimeCount += 1
    }
    
    func sendDwellTime(value: Int64, completion: SuperAwesome.OnResult<Void>?) {
        completion?(response)
        sendDwellTimeCount += 1
    }
}

