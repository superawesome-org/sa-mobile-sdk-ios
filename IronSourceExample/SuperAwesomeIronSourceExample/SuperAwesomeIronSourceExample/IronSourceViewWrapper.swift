//
//  ContentView.swift
//  SuperAwesomeIronSourceExample
//
//  Created by Matheus Finatti on 31/07/2023.
//

import SwiftUI
import IronSource

struct IronSourceViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = IronSourceViewController

    func makeUIViewController(context: Context) -> IronSourceViewController {
        return IronSourceViewController()
    }

    func updateUIViewController(_ uiViewController: IronSourceViewController, context: Context) {

    }
}
