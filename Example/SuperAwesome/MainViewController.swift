//
//  MainViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 22/04/2020.
//

import UIKit
@testable import SuperAwesome

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = DependencyContainer()
        container.register { c in ComponentModule(c.resolve() as RepositoryModuleType) as ComponentModuleType }
        container.register { c in NetworkModule(c.resolve() as ComponentModuleType) as NetworkModuleType }
        container.register { c in RepositoryModule(c.resolve() as NetworkModuleType) as RepositoryModuleType }
        
        let repositoryModule: RepositoryModuleType = container.resolve()
        let adRepository: AdRepositoryType = repositoryModule.resolve()
        
        print("MainViewController makeRequest")
        adRepository.getAd(placementId: 1, request: AdRequest(environment: .staging, test: false, pos: 1, skip: 1,
                                                              playbackmethod: 1, startdelay: 1,
                                                              instl: 1, w: 300, h: 300))
        { result in
            print("MainViewController Result: isSuccess:\(result.isSuccess)")
        }
    }
}
