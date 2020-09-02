//
//  AwesomeAdsViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 21/08/2020.
//

import UIKit
import SuperAwesome

class AwesomeAdsViewController: UIViewController {
    private var bannerView: BannerView!
    
    private let bannerId = 44258
    private let interstitialId = 44259
    private let videoId = 44259
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.9)
        
        initUI()
        
        bannerView.setCallback { (placementId, event) in
            switch event {
                
            case .adLoaded:
                print(" >> Ad adLoaded ")
                self.bannerView.play()
                break
            case .adEmpty:
                print(" >> Ad adEmpty ")
                break
            case .adFailedToLoad:
                print(" >> Ad adFailedToLoad ")
                break
            case .adAlreadyLoaded:
                print(" >> Ad adAlreadyLoaded ")
                break
            case .adShown:
                print(" >> Ad adShown ")
                break
            case .adFailedToShow:
                print(" >> Ad adFailedToShow ")
                break
            case .adClicked:
                print(" >> Ad adClicked ")
                break
            case .adEnded:
                print(" >> Ad adEnded ")
                break
            case .adClosed:
                print(" >> Ad adClosed ")
                break
            }
        }
        
        let configuration = AwesomeAdsSdk.Configuration(environment: .production, logging: true)
        AwesomeAdsSdk.shared.initSdk(configuration: configuration) {
            print("AwesomeAds SDK init complete")
            self.bannerView.load(self.bannerId)
        }
    }
    
    private func initUI() {
        // banner view
        bannerView = BannerView()
        bannerView.enableParentalGate()
        
        bannerView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
