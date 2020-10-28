//
//  LoggerMock.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

@testable import SuperAwesome

struct LoggerMock: LoggerType {
    func info(_ message: String) {
        
    }
    
    func info(_ message: String, depth: Int) {
        
    }
    
    func success(_ message: String) {
        
    }
    
    func error(_ message: String, error: Error) {
        
    }
    
    func tag(_ tag: String) -> LoggerType {
        self
    }
}
