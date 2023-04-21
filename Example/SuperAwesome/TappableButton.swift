//
//  TappableButton.swift
//  SuperAwesomeExample
//
//  Created by Myles Eynon on 30/03/2023.
//

import UIKit

extension UIControl.State: Hashable {}

open class TappableButton: UIButton {
    open var onTap: (() -> Void)?

    open var canAdjustTitleRectAlignment: Bool = false

    private var borderColorDict: [UIControl.State: UIColor] = [:]
    private var shadowColorDict: [UIControl.State: UIColor] = [:]
    private var imageTintDict: [UIControl.State: UIColor] = [:]
    private var fontDict: [UIControl.State: UIFont] = [:]

    private var textObserver: NSKeyValueObservation?

    public var shadowLayer: CALayer?
    public var isScaleEnabled: Bool = true

    open override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            updateStyle()
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            updateStyle()
        }
    }

    open override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            updateStyle()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
        addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
    }

    @objc
    open func onTapButton() {
        onTap?()
    }

    open func setImageTint(_ color: UIColor?, for state: UIControl.State) {
        imageTintDict[state] = color
        updateStyle()
    }

    open func setShadowColor(_ color: UIColor?, for state: UIControl.State) {
        shadowColorDict[state] = color
        updateStyle()
    }

    open func setFont(_ font: UIFont?, for state: UIControl.State) {
        fontDict[state] = font
        updateStyle()
    }

    private func updateStyle() {
        let oldFont = titleLabel?.font
        let oldTint = imageView?.tintColor
        let oldShadow = layer.shadowColor
        let oldBorderColor = layer.borderColor

        titleLabel?.font = fontDict[state] ?? fontDict[.normal] ?? oldFont
        imageView?.tintColor = imageTintDict[state] ?? imageTintDict[.normal] ?? oldTint
        shadowLayer?.shadowColor = shadowColorDict[state]?.cgColor ?? oldShadow
        layer.borderColor = borderColorDict[state]?.cgColor ?? borderColorDict[.normal]?.cgColor ?? oldBorderColor
    }

    private func calculateTitleRect() -> CGRect? {
        guard let text: String = titleLabel?.text else { return nil }
        var rects: [CGRect] = [CGRect]()
        let size: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .zero)
        if let uNormalFont: UIFont = fontDict[.normal] {
            let attributes: [NSAttributedString.Key: Any] = [.font: uNormalFont]
            let rect: CGRect = rect(forAttributes: attributes, string: text, size: size)
            rects.append(rect)
        }
        if let uSelectedFont = fontDict[.selected] {
            let attributes: [NSAttributedString.Key: Any] = [.font: uSelectedFont]
            let rect: CGRect = rect(forAttributes: attributes, string: text, size: size)
            rects.append(rect)
        }
        if let uHighlightedFont = fontDict[.highlighted] {
            let attributes: [NSAttributedString.Key: Any] = [.font: uHighlightedFont]
            let rect: CGRect = rect(forAttributes: attributes, string: text, size: size)
            rects.append(rect)
        }
        if let uDisabledFont = fontDict[.disabled] {
            let attributes: [NSAttributedString.Key: Any] = [.font: uDisabledFont]
            let rect: CGRect = rect(forAttributes: attributes, string: text, size: size)
            rects.append(rect)
        }
        var maxRect: CGRect = CGRect.zero
        rects.forEach {
            if $0.width > maxRect.width {
                maxRect = $0
            }
        }
        let maxRectWidth: CGFloat = ceil(maxRect.width)
        let maxRectHeight: CGFloat = ceil(maxRect.height)
        return CGRect(x: .zero, y: .zero, width: maxRectWidth, height: maxRectHeight)
    }

    private func rect(forAttributes attributes: [NSAttributedString.Key: Any], string: String, size: CGSize) -> CGRect {
        let nsString: NSString = NSString(string: string)
        return nsString.boundingRect(with: size,
                                     options: .usesFontLeading,
                                     attributes: attributes,
                                     context: nil)
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect: CGRect = super.titleRect(forContentRect: contentRect)
        guard canAdjustTitleRectAlignment else {
            return superRect
        }

        let titleRect: CGRect = calculateTitleRect() ?? superRect
        let imageSize: CGSize = currentImage?.size ?? .zero
        var availableWidth: CGFloat = contentRect.width
        availableWidth -= imageEdgeInsets.right
        availableWidth -= imageSize.width
        availableWidth -= titleRect.width
        let roundedWidth: CGFloat = round(availableWidth / 2.0)
        return titleRect.offsetBy(dx: roundedWidth, dy: .zero)
    }

    deinit {
        textObserver?.invalidate()
        textObserver = nil
    }
}
