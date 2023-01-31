//
//  Binding.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 20/01/2023.
//

import SwiftUI

extension Binding {

    func onChange(perform action: @escaping (Value, Value) -> Void) -> Self {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                let oldValue = self.wrappedValue
                DispatchQueue.main.async { action(newValue, oldValue) }
                self.wrappedValue = newValue
            }
        )
    }
}
