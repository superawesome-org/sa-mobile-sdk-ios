//
//  Injectable.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/04/2020.
//

@objc(SADependencyContainer)
public class DependencyContainer: NSObject {
    @objc(dependencies)
    public static let dependencies: ModuleContainerType = ModuleContainer()
}

@objc(SAInjactable)
protocol Injactable {
    @objc(dependencies)
    var dependencies: ModuleContainerType { get }
}

extension Injactable {
    var dependencies: ModuleContainerType { DependencyContainer.dependencies }
}
