//
//  Logger.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/08/2020.
//

import os

protocol LoggerType {
    func info(_ message: String)
    func info(_ message: String, depth: Int)
    func success(_ message: String)
    func error(_ message: String, error: Error)
}

public class OsLogger: LoggerType {
    func info(_ message: String) {
        info(message, depth: 0)
    }
    
    func info(_ message: String, depth: Int) {
        let depthString = String(repeating: "→ ", count: depth)
        os_log("%@", log: OSLog.default, type: OSLogType.info, "⬜️ \(depthString)\(message)")
    }
    
    public func success(_ message: String) {
        os_log("%@", log: OSLog.default, type: OSLogType.info, "🟩 \(message)")
    }
    
    func error(_ message: String, error: Error) {
        os_log("%@", log: OSLog.default, type: OSLogType.error, "🟥 \(message) \n \(error.localizedDescription)")
    }
}
