//
//  UITestSetup.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import Foundation

class UITestSetup {

    private static let UITestFlag = "--UITests"
    private static let AirplaneModeFlag = "--AirplaneMode"

    private static let persistanceFlag = "clearPersistantData"

//    private let uiTestDataFolderURL = DependencyProvider.shared.uiTestDataFolderURL
//
//    private var testPreferences: UITestPreferences = DependencyProvider.shared.resolve()

    func mockDependencyInjection() {

//        if isInTestMode {
//            if ProcessInfo.processInfo.environment[UITestSetup.featureFlagsFlag] != nil {
//                clearTestData()
//                createTestFolder()
//            }
//        }
    }

    func setupTestEnvironment() {

        if isInTestMode && shouldClearPeristance {
            clearPeristance()
        }

        if isInAirplaneMode {
//            MockConnectionRequestHandler.enableAirplaneMode()
        }
    }

    private func clearPeristance() {
//        UserDefaults.standard.removeAllMockKeys()
    }

    internal var shouldClearPeristance: Bool {
        ProcessInfo.processInfo.environment[UITestSetup.persistanceFlag] == "true"
    }

    internal var isInTestMode: Bool {
        CommandLine.arguments.contains(UITestSetup.UITestFlag)
    }

    internal var isInAirplaneMode: Bool {
        CommandLine.arguments.contains(UITestSetup.AirplaneModeFlag)
    }

    // MARK: Event Log File Management

    private func clearTestData() {
//        try? FileManager.default.removeItem(at: uiTestDataFolderURL)
    }

    private func createTestFolder() {
//        let manager = FileManager.default
//        if !manager.fileExists(atPath: uiTestDataFolderURL.absoluteString) {
//            try? manager.createDirectory(at: uiTestDataFolderURL, withIntermediateDirectories: true, attributes: nil)
//        }
    }
}
