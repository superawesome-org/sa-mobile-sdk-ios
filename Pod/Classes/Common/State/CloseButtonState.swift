//
//  CloseButtonState.swift
//  SuperAwesome
//
//  Created by Tom O'Rourke on 08/06/2022.
//

@objc
public enum CloseButtonState: Int {
    case visibleWithDelay = 0
    case visibleImmediately = 1
    case hidden = 2
}

@objc
public class CloseButtonStateHelper: NSObject {
    /// Creates a `CloseButtonState` enum from an `int` value.
    @objc
    public class func from(_ value: Int) -> CloseButtonState {
        CloseButtonState(rawValue: value) ?? Constants.defaultCloseButton
    }
}
