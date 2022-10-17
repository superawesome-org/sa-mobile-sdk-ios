//
//  MainViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 02/02/2022.
//

import UIKit
import SuperAwesome

enum RowType: String {
    case banner = "Banner"
    case interstitial = "Interstitial"
    case video = "Video"
}

protocol AdRow {
    var type: RowType { get }
    var name: String { get }
    var placementId: Int { get }
}

struct SingleIdRow: AdRow {
    let type: RowType
    let name: String
    let placementId: Int
}

struct MultiIdRow: AdRow {
    let type: RowType
    let name: String
    let placementId: Int
    let lineItemId: Int
    let creativeId: Int
}

private let rows: [AdRow] = [
    MultiIdRow(
        type: .banner,
        name: "Leaderboard MultiId",
        placementId: 82088,
        lineItemId: 176803,
        creativeId: 499387
    ),
    SingleIdRow(
        type: .interstitial,
        name: "Portrait",
        placementId: 87892
    ),
    MultiIdRow(
        type: .interstitial,
        name: "Portrait MultiId",
        placementId: 82089,
        lineItemId: 176803,
        creativeId: 503038
    ),
    SingleIdRow(
        type: .video,
        name: "Direct MultiId",
        placementId: 82090
    ),
    SingleIdRow(
        type: .video,
        name: "VPAID via KSF",
        placementId: 84798
    ),
    SingleIdRow(
        type: .video,
        name: "VPAID non-KSF",
        placementId: 89056
    ),
    SingleIdRow(
        type: .video,
        name: "Direct video flat",
        placementId: 87969
    )
]

class MainViewController: UIViewController {
    private var headerLabel: UILabel!
    private var bannerView: BannerView!
    private var segment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        BumperPage.overrideName("Demo App")

        initUI()
    }

    func configuration1() {
        bannerView.enableParentalGate()
        bannerView.enableBumperPage()

        InterstitialAd.enableParentalGate()
        InterstitialAd.enableBumperPage()

        VideoAd.enableParentalGate()
        VideoAd.enableBumperPage()

        // Normal close button configuration
        VideoAd.enableCloseButton()
        InterstitialAd.enableCloseButton()
    }

    func configuration2() {
        bannerView.disableParentalGate()
        bannerView.disableBumperPage()

        InterstitialAd.disableParentalGate()
        InterstitialAd.disableBumperPage()

        VideoAd.disableParentalGate()
        VideoAd.disableBumperPage()

        // Close button configured with no delay
        VideoAd.enableCloseButtonNoDelay()
        InterstitialAd.enableCloseButtonNoDelay()
    }

    private func initUI() {
        initHeader()
        initSegment()
        initBannerView()
        initButtons()
        configureInterstitial()
        configureVideo()
    }

    private func initHeader() {
        let version = AwesomeAds.info()?.versionNumber ?? ""
        headerLabel = UILabel()
        headerLabel.text = "AwesomeAds.version: \(version)"
        headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 16)
        ])
    }

    private func initSegment() {
        let segment = UISegmentedControl(items: ["Enable checks", "Disable checks"])
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.accessibilityIdentifier = "configControl"

        view.addSubview(segment)

        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            segment.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
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
        bannerView.backgroundColor = UIColor.gray
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])

        bannerView.setCallback { (_, event) in
            print(" bannerView >> \(event.name())")

            if event == .adLoaded {
                self.bannerView.play()
            }
        }
    }

    private func configureInterstitial() {
        InterstitialAd.setCallback { (placementId, event) in
            print(" InterstitialAd >> \(event.name())")

            if event == .adLoaded {
                InterstitialAd.play(placementId, fromVC: self)
            }
        }
    }

    private func configureVideo() {
        VideoAd.enableCloseButton()
        VideoAd.setCallback { (placementId, event) in
            print(" VideoAd >> \(event.name())")

            if event == .adLoaded {
                VideoAd.play(withPlacementId: placementId, fromVc: self)
            }
        }
    }

    private func initButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = "adsStackView"

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bannerView.topAnchor),
            stackView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 16.0)
        ])

        for (index, row) in rows.enumerated() {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 8.0
            horizontalStack.alignment = .fill
            horizontalStack.distribution = .fillEqually

            let label = UILabel()
            label.text = "\(row.type.rawValue) (\(row.name))"
            label.font = UIFont(name: "HelveticaNeue-Light", size: 14)

            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("\(row.placementId)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setBackgroundColor(color: UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1.0), forState: .highlighted)
            button.setBackgroundColor(color: UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0), forState: .normal)
            button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
            button.tag = index
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

            horizontalStack.addArrangedSubview(label)
            horizontalStack.addArrangedSubview(button)

            stackView.addArrangedSubview(horizontalStack)
        }
    }

    @objc private func onButtonClick(_ sender: UIButton) {
        let item = rows[sender.tag]
        if let item = item as? SingleIdRow {
            handleSingleIdRowTapped(item: item)
        } else if let item = item as? MultiIdRow {
            handleMultiIdRowTapped(item: item)
        }
    }

    private func handleSingleIdRowTapped(item: SingleIdRow) {

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

    private func handleMultiIdRowTapped(item: MultiIdRow) {

        print("\(item.type.rawValue) clicked"
              + " for placement id: \(item.placementId)"
              + " lineItemId: \(item.lineItemId)"
              + " creativeId: \(item.creativeId)"
        )

        switch item.type {
        case .banner:
            bannerView.load(
                item.placementId,
                lineItemId: item.lineItemId,
                creativeId: item.creativeId
            )
        case .interstitial:
            InterstitialAd.load(
                item.placementId,
                lineItemId: item.lineItemId,
                creativeId: item.creativeId
            )
        case .video:
            VideoAd.load(
                withPlacementId: item.placementId,
                lineItemId: item.lineItemId,
                creativeId: item.creativeId
            )
        }
    }
}
