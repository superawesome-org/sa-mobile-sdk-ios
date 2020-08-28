//
//  ParentalGate.swift
//  Alamofire
//
//  Created by Gunhan Sancar on 25/08/2020.
//

import UIKit

protocol ParentalGateDelegate {
    func parentalGateOpenned()
    func parentalGateCancelled()
    func parentalGateFailed()
    func parentalGateSuccess()
    
    func parentalGateStopped()
}

class ParentalGate {
    public var delegate: ParentalGateDelegate?
    
    private var topWindow: UIWindow?
    private var challangeAlertController: UIAlertController?
    
    private var firstNumber: Int = 0
    private var secondNumber: Int = 0
    private var solution: Int = 0
    
    
    private let numberGenerator: NumberGeneratorType
    private let stringProvider: StringProviderType
    
    
    init(numberGenerator:NumberGeneratorType,
         stringProvider: StringProviderType) {
        self.numberGenerator = numberGenerator
        self.stringProvider = stringProvider
        newQuestion()
    }
    
    func stop() {
        topWindow?.isHidden = true
        topWindow = nil
        challangeAlertController?.dismiss(animated: true, completion: nil)
        delegate?.parentalGateStopped()
    }
    
    func show() {
        challangeAlertController = UIAlertController(title: stringProvider.parentalGateTitle,
                                                message: stringProvider.parentalGateMessage(
                                                    firstNumber: firstNumber, secondNumber: secondNumber),
                                                preferredStyle: .alert)
        
        let continueAction = UIAlertAction(title: stringProvider.continueTitle, style: .default) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: stringProvider.cancelTitle, style: .default) { [weak self] _ in
            self?.stop()
        }


        challangeAlertController?.addAction(cancelAction)
        challangeAlertController?.addAction(continueAction)

        var localTextField: UITextField?

        challangeAlertController?.addTextField(configurationHandler: { textField in
            localTextField = textField
            localTextField?.keyboardType = .numberPad
        })
        
        topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow?.rootViewController = UIViewController()
        topWindow?.windowLevel = UIWindow.Level(UIWindow.Level.alert.rawValue + 1)
        topWindow?.makeKeyAndVisible()
        topWindow?.rootViewController?.present(challangeAlertController!, animated: true)
    }
    
    private func newQuestion() {
        firstNumber = numberGenerator.nextIntForParentalGate()
        secondNumber = numberGenerator.nextIntForParentalGate()
        solution = firstNumber + secondNumber
    }
    
}
