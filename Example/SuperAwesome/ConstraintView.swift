//
//  ConstraintView.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import UIKit

open class ConstraintView: UIView {

    public var didSetupConstraints: Bool = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() {
        addSubViews()
        setNeedsUpdateConstraints()
    }

    open func addSubViews() {
        // Override and add subviews here
    }

    open func addConstraints() {
        // Override and add constraints here
    }

    open func modifyConstraints() {
        // Override and modify constraints here
    }

    override open func updateConstraints() {
        if !didSetupConstraints {
            didSetupConstraints = true
            addConstraints()
        }
        modifyConstraints()
        super.updateConstraints()
    }
}
