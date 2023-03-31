//
//  Settings.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import SuperAwesome

enum Settings {
    case environment
    case closeButtonMode
    case testMode
    case bumper
    case parentalGate
    case playAdImmediately
    case muteOnStart
    case leaveVideoWarning
    case closeAtEnd

    var name: String {
        NSLocalizedString("Settings.Item.\(identifier)", comment: identifier)
    }

    var identifier: String {
        switch self {
        case .environment:
            return "Environment"
        case .closeButtonMode:
            return "CloseButtonMode"
        case .testMode:
            return "TestMode"
        case .bumper:
            return "Bumper"
        case .parentalGate:
            return "ParentalGate"
        case .playAdImmediately:
            return "PlayAdImmediately"
        case .muteOnStart:
            return "MuteOnStart"
        case .leaveVideoWarning:
            return "LeaveVideoWarning"
        case .closeAtEnd:
            return "CloseAtEnd"
        }
    }

    var options: [SettingsItemOption] {
        switch self {
        case .environment:
            return [
                SettingsItemOption(identifier: "UITesting",
                                   name: NSLocalizedString("Settings.Item.Option.Environment.UITesting",
                                                           comment: "UI Testing"),
                                   value: SuperAwesome.Environment.uitesting),
                SettingsItemOption(identifier: "Production",
                                   name: NSLocalizedString("Settings.Item.Option.Environment.Production",
                                                           comment: "Production"),
                                   value: SuperAwesome.Environment.production)
            ]
        case .closeButtonMode:
            return [
                SettingsItemOption(identifier: "NoDelay",
                                   name: NSLocalizedString("Settings.Item.Option.CloseButtonMode.NoDelay",
                                                           comment: "No Delay"),
                                   value: CloseButtonState.visibleImmediately),
                SettingsItemOption(identifier: "Delay",
                                   name: NSLocalizedString("Settings.Item.Option.CloseButtonMode.Delay",
                                                           comment: "Delay"),
                                   value: CloseButtonState.visibleWithDelay),
                SettingsItemOption(identifier: "Hidden",
                                   name: NSLocalizedString("Settings.Item.Option.CloseButtonMode.Hidden",
                                                           comment: "Hidden"),
                                   value: CloseButtonState.hidden)
            ]
        case .testMode:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        case .bumper:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        case .parentalGate:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        case .playAdImmediately:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        case .muteOnStart:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        case .leaveVideoWarning:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        case .closeAtEnd:
            return [SettingsItemOption.Enable, SettingsItemOption.Disable]
        }
    }

    static var all: [Settings] {
        [.environment,
         .closeButtonMode,
         .testMode,
         .bumper,
         .parentalGate,
         .playAdImmediately,
         .muteOnStart,
         .leaveVideoWarning,
         .closeAtEnd]
    }
}
