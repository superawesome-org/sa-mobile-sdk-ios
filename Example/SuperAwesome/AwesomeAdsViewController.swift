//
//  AwesomeAdsViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 21/08/2020.
//

import UIKit
import SuperAwesome

enum RowType: String {
    case banner = "Banner"
    case interstitial = "Interstitial"
    case video = "Video"
}

struct Row {
    let type: RowType
    let placementId: Int
}

private let rows = [
    Row(type: .banner, placementId: 44258),
    Row(type: .interstitial, placementId: 44259),
    Row(type: .video, placementId: 44261)
]

class AwesomeAdsViewController: UIViewController {
    private var bannerView: BannerView!
    private var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BumperPage.overrideName("Demo App")
        
        let configuration = AwesomeAds.Configuration(environment: .production, logging: true)
        AwesomeAds.initSDK(configuration: configuration) {
            print("AwesomeAds SDK init complete")
        }
        
        initUI()
    }
    
    func configuration1() {
        bannerView.enableParentalGate()
        bannerView.enableBumperPage()
        
        InterstitialAd.enableParentalGate()
        InterstitialAd.enableBumperPage()
    }
    
    func configuration2() {
        bannerView.disableParentalGate()
        bannerView.disableBumperPage()
        
        InterstitialAd.disableParentalGate()
        InterstitialAd.disableBumperPage()
    }
    
    private func initUI() {
        initSegment()
        initBannerView()
        initButtons()
        configureInterstitial()
        configureVideo()
    }
    
    private func initSegment() {
        let segment = UISegmentedControl(items: ["Config 1", "Config 2"])
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segment)
        
        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            segment.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0),
            segment.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.segment = segment
    }
    
    @objc func segmentChanged() {
        let idx = segment.selectedSegmentIndex
        switch idx {
        case 0:
            configuration1()
            print("configuration 1")
        case 1:
            configuration2()
            print("configuration 2")
        default:
            print("configuration none")
        }
    }
    
    private func initBannerView() {
        // banner view
        bannerView = BannerView()
        bannerView.enableBumperPage()
        //bannerView.enableParentalGate()
        
        bannerView.backgroundColor = UIColor.gray
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        bannerView.setCallback { (placementId, event) in
            switch event {
            
            case .adLoaded:
                print(" bannerView >> Ad adLoaded ")
                self.bannerView.play()
                break
            case .adEmpty:
                print(" bannerView >> Ad adEmpty ")
                break
            case .adFailedToLoad:
                print(" bannerView >> Ad adFailedToLoad ")
                break
            case .adAlreadyLoaded:
                print(" bannerView >> Ad adAlreadyLoaded ")
                break
            case .adShown:
                print(" bannerView >> Ad adShown ")
                break
            case .adFailedToShow:
                print(" bannerView >> Ad adFailedToShow ")
                break
            case .adClicked:
                print(" bannerView >> Ad adClicked ")
                break
            case .adEnded:
                print(" bannerView >> Ad adEnded ")
                break
            case .adClosed:
                print(" bannerView >> Ad adClosed ")
                break
            }
        }
    }
    
    private func configureInterstitial() {
        InterstitialAd.setCallback { (placementId, event) in
            switch event {
            
            case .adLoaded:
                InterstitialAd.play(placementId, fromVC: self)
                break
            case .adEmpty:
                print(" InterstitialAd >> Ad adEmpty ")
                break
            case .adFailedToLoad:
                print(" InterstitialAd >> Ad adFailedToLoad ")
                break
            case .adAlreadyLoaded:
                print(" InterstitialAd >> Ad adAlreadyLoaded ")
                break
            case .adShown:
                print(" InterstitialAd >> Ad adShown ")
                break
            case .adFailedToShow:
                print(" InterstitialAd >> Ad adFailedToShow ")
                break
            case .adClicked:
                print(" InterstitialAd >> Ad adClicked ")
                break
            case .adEnded:
                print(" InterstitialAd >> Ad adEnded ")
                break
            case .adClosed:
                print(" InterstitialAd >> Ad adClosed ")
                break
            }
        }
    }
    
    private func configureVideo() {
        VideoAd.enableCloseButton()
        VideoAd.setCallback { (placementId, event) in
            switch event {
            
            case .adLoaded:
                VideoAd.play(withPlacementId: placementId, fromVc: self)
                break
            case .adEmpty:
                print(" VideoAd >> Ad adEmpty ")
                break
            case .adFailedToLoad:
                print(" VideoAd >> Ad adFailedToLoad ")
                break
            case .adAlreadyLoaded:
                print(" VideoAd >> Ad adAlreadyLoaded ")
                break
            case .adShown:
                print(" VideoAd >> Ad adShown ")
                break
            case .adFailedToShow:
                print(" VideoAd >> Ad adFailedToShow ")
                break
            case .adClicked:
                print(" VideoAd >> Ad adClicked ")
                break
            case .adEnded:
                print(" VideoAd >> Ad adEnded ")
                break
            case .adClosed:
                print(" VideoAd >> Ad adClosed ")
                break
            }
        }
    }
    
    private func initButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bannerView.topAnchor),
            stackView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 16.0)
        ])
        
        for (index, row) in rows.enumerated() {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("  \(row.type.rawValue) - \(row.placementId)  ", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor.white
            button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
            button.tag = index
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 2.0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 4.0
            
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func onButtonClick(_ sender: UIButton) {
        let item = rows[sender.tag]
        print("\(item.type.rawValue) clicked for \(item.placementId)")
        
        switch item.type {
        case .banner:
            bannerView.load(item.placementId)
        case .interstitial:
            InterstitialAd.load(item.placementId)
        case .video:
            VideoAd.load(withPlacementId: item.placementId)
        }
    }
}

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
}
