//
//  SettingsItemOption.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import Foundation

struct SettingsItemOption {
    var identifier: String
    var name: String
    var value: Any

    static let Enable: SettingsItemOption =
        SettingsItemOption(identifier: "Enable",
                           name: NSLocalizedString("Settings.Item.Option.Enable", comment: "Enable"),
                           value: true)

    static let Disable: SettingsItemOption =
        SettingsItemOption(identifier: "Disable",
                           name: NSLocalizedString("Settings.Item.Option.Disable", comment: "Disable"),
                           value: false)
}
