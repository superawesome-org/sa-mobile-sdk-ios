//
//  UIModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/11/2020.
//

class UIModule: DependencyModule {
    func register(_ container: DependencyContainer) {
        container.factory(ViewableDetectorType.self) { c, param in
            ViewableDetector(logger: c.resolve(param: ViewableDetector.self)) }
        container.single(AdControllerType.self) { _, _ in AdController() }
        container.factory(ParentalGate.self) { c, _ in
            ParentalGate(numberGenerator: c.resolve(), stringProvider: c.resolve()) }
    }
}
