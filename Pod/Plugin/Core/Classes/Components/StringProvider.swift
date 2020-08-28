//
//  StringProvider.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 25/08/2020.
//

protocol StringProviderType {
    var parentalGateTitle: String { get }
    func parentalGateMessage(firstNumber: Int, secondNumber: Int) -> String
    var cancelTitle: String { get }
    var continueTitle: String { get }
    var errorTitle: String { get }
    var errorMessage: String { get }
    var okTitle: String { get }
}

class StringProvider: StringProviderType {
    var parentalGateTitle = "Parental Gate"
    func parentalGateMessage(firstNumber: Int, secondNumber: Int) -> String {
        "Please solve the following problem to continue:\n\(firstNumber) + \(secondNumber) = ?"
    }
    var cancelTitle = "Cancel"
    var continueTitle = "Continue"
    var errorTitle = "Oops! That was the wrong answer."
    var errorMessage = "Please seek guidance from a responsible adult to help you continue."
    var okTitle = "Ok"
}
