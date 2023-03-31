//
//  TappableView.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import UIKit

open class TappableView: ConstraintView {

    private var gesture: UITapGestureRecognizer!

    open var onTap: (() -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        createRecogniser()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createRecogniser()
    }

    private func createRecogniser() {
        isUserInteractionEnabled = true
        gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(gesture)
    }

    @objc
    private func didTap() {
        onTap?()
    }
}
