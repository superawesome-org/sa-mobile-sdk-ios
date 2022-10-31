//
//  LaunchUtils.swift
//  SuperAwesomeExample
//
//  Created by Tom O'Rourke on 30/10/2022.
//

struct LaunchUtils {
    static func shouldRunLocal() -> Bool {
        return CommandLine.arguments.contains("-runlocal")
    }
}
