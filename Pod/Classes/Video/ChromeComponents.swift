//
//  ChromeComponents.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit

@objc(SABlackMask) class BlackMask: UIView {
    
    override func didMoveToSuperview() {
        backgroundColor = UIColor.clear
        guard let parentFrame = superview?.frame else { return }
        alpha = 0.75
        frame = CGRect(x: 0, y: parentFrame.size.height - 40, width: parentFrame.size.width, height: 40)
        let layer = getGradientLayer()
        layer.addSublayer(layer)
    }
    
    private func getGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0.7)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }
}

extension UILabel {
    static func createChrono() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.center
        return label
    }
}

@objc(SAChronograph) class Chronograph: UIView {
    
    private let adLabel = UILabel.createChrono()
    
    override func didMoveToSuperview() {
        guard let parentFrame = superview?.frame else { return }
        let H = 20, W = 50, X = 10
        let Y = parentFrame.size.height - 30
        frame = CGRect(x: X, y: Int(Y), width: W, height: H)
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        layer.cornerRadius = 5.0
        
        adLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        addSubview(adLabel)
    }
    
    @objc(setRemainingTime:)
    public func setTime(remaining: Int) {
        adLabel.text = "Ad: \(remaining)"
    }
}

@objc(SAURLClicker) class URLClicker: UIButton {
    
}
