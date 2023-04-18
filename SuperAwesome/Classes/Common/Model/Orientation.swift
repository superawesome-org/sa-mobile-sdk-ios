//
//  Orientation.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/09/2020.
//

@objc
public enum Orientation: Int {
    case any = 0
    case portrait = 1
    case landscape = 2
}

@objc
public class OrientationHelper: NSObject {
    /// Creates `Orientation` enum from `int` value.
    @objc
    public class func from(_ value: Int) -> Orientation {
        Orientation(rawValue: value) ?? Constants.defaultOrientation
    }
}
