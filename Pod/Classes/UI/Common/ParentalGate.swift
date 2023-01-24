//
//  ParentalGate.swift
//  Alamofire
//
//  Created by Gunhan Sancar on 25/08/2020.
//

import UIKit

class ParentalGate {
    private var challangeAlertController: UIAlertController?
    private var errorAlertController: UIAlertController?

    private var firstNumber: Int = 0
    private var secondNumber: Int = 0
    private var solution: Int = 0

    var openAction: VoidBlock?
    var cancelAction: VoidBlock?
    var failAction: VoidBlock?
    var successAction: VoidBlock?

    private let numberGenerator: NumberGeneratorType
    private let stringProvider: StringProviderType

    init(numberGenerator: NumberGeneratorType, stringProvider: StringProviderType) {
        self.numberGenerator = numberGenerator
        self.stringProvider = stringProvider
        newQuestion()
    }

    func stop() {
        challangeAlertController?.dismiss(animated: true, completion: nil)
        errorAlertController?.dismiss(animated: true, completion: nil)
    }

    func show() {
        challangeAlertController = UIAlertController(title: stringProvider.parentalGateTitle,
                                                message: stringProvider.parentalGateMessage(
                                                    firstNumber: firstNumber, secondNumber: secondNumber),
                                                preferredStyle: .alert)

        let continueAction = UIAlertAction(title: stringProvider.continueTitle, style: .default) { [weak self] _ in
            self?.onContinue()
        }

        let cancelAction = UIAlertAction(title: stringProvider.cancelTitle, style: .default) { [weak self] _ in
            self?.stop()
            self?.cancelAction?()
        }

        if let controller = challangeAlertController {
            controller.addAction(cancelAction)
            controller.addAction(continueAction)
            controller.addTextField(configurationHandler: { textField in
                textField.keyboardType = .numberPad
            })
            controller.modalTransitionStyle = .crossDissolve
            UIApplication.shared.keyWindow?.rootViewController?.getTopMostViewController().present(controller,
                                                                                                   animated: true)
        }

        self.openAction?()
    }

    private func onSuccessfulAttempt() {
        stop()
        self.successAction?()
    }

    private func onFailedAttempt() {
        stop()

        errorAlertController = UIAlertController(title: stringProvider.errorTitle,
                                                message: stringProvider.errorMessage,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: stringProvider.cancelTitle, style: .default) { [weak self] _ in
            self?.stop()
            self?.failAction?()
        }

        if let controller = errorAlertController {
            controller.addAction(okAction)
            controller.modalTransitionStyle = .crossDissolve
            UIApplication.shared.keyWindow?.rootViewController?.getTopMostViewController().present(controller,
                                                                                                   animated: true)
        }
    }

    private func onContinue() {
        let textField = challangeAlertController?.textFields?.first
        textField?.resignFirstResponder()

        if textField?.text?.toInt ?? 0 == solution {
            onSuccessfulAttempt()
        } else {
            onFailedAttempt()
        }
    }

    private func newQuestion() {
        firstNumber = numberGenerator.nextIntForParentalGate()
        secondNumber = numberGenerator.nextIntForParentalGate()
        solution = firstNumber + secondNumber
    }

}
