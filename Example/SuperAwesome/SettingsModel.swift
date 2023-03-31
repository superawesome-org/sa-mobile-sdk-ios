//
//  SettingsModel.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import SuperAwesome

class SettingsModel {

    var closeButtonMode: SettingValue<CloseButtonState> =
        SettingValue(setting: .closeButtonMode, value: CloseButtonState.visibleWithDelay)

    var isTestModeEnabled: SettingValue<Bool> = SettingValue(setting: .testMode, value: false)

    var isBumperEnabled: SettingValue<Bool> = SettingValue(setting: .bumper, value: false)

    var isParentalGateEnabled: SettingValue<Bool> = SettingValue(setting: .parentalGate, value: false)

    var isPlayAdImmediatelyEnabled: SettingValue<Bool> = SettingValue(setting: .playAdImmediately, value: true)

    var isVideoMutedOnStart: SettingValue<Bool> = SettingValue(setting: .muteOnStart, value: false)

    var isVideoLeaveWarningEnabled: SettingValue<Bool> = SettingValue(setting: .leaveVideoWarning, value: false)

    var isVideoCloseAtEndEnabled: SettingValue<Bool> = SettingValue(setting: .closeAtEnd, value: true)

    func getValue(forSetting setting: Settings) -> Any {
        switch setting {
        case .closeButtonMode:
            return closeButtonMode.value
        case .testMode:
            return isTestModeEnabled.value
        case .bumper:
            return isBumperEnabled.value
        case .parentalGate:
            return isParentalGateEnabled.value
        case .playAdImmediately:
            return isPlayAdImmediatelyEnabled.value
        case .muteOnStart:
            return isVideoMutedOnStart.value
        case .leaveVideoWarning:
            return isVideoLeaveWarningEnabled.value
        case .closeAtEnd:
            return isVideoCloseAtEndEnabled.value
        }
    }

    func setValue(forSetting setting: Settings, value: Any) {
        switch setting {
        case .closeButtonMode:
            guard let mode = value as? CloseButtonState else { return }
            closeButtonMode = SettingValue(setting: .closeButtonMode, value: mode)
        case .testMode:
            guard let isEnabled = value as? Bool else { return }
            isTestModeEnabled = SettingValue(setting: .testMode, value: isEnabled)
        case .bumper:
            guard let isEnabled = value as? Bool else { return }
            isBumperEnabled = SettingValue(setting: .bumper, value: isEnabled)
        case .parentalGate:
            guard let isEnabled = value as? Bool else { return }
            isParentalGateEnabled = SettingValue(setting: .parentalGate, value: isEnabled)
        case .playAdImmediately:
            guard let isEnabled = value as? Bool else { return }
            isPlayAdImmediatelyEnabled = SettingValue(setting: .playAdImmediately, value: isEnabled)
        case .muteOnStart:
            guard let isEnabled = value as? Bool else { return }
            isVideoMutedOnStart = SettingValue(setting: .muteOnStart, value: isEnabled)
        case .leaveVideoWarning:
            guard let isEnabled = value as? Bool else { return }
            isVideoLeaveWarningEnabled = SettingValue(setting: .leaveVideoWarning, value: isEnabled)
        case .closeAtEnd:
            guard let isEnabled = value as? Bool else { return }
            isVideoCloseAtEndEnabled = SettingValue(setting: .closeAtEnd, value: isEnabled)
        }
    }
}

struct SettingValue<T> {
    let setting: Settings
    let value: T
}
