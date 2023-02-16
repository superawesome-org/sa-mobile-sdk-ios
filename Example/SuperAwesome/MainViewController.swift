//
//  MainViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 02/02/2022.
//

import UIKit
import SuperAwesome
import FirebaseDatabase
import FirebaseDatabaseSwift

enum RowType: String, Decodable {
    case banner = "BANNER"
    case interstitial = "INTERSTITIAL"
    case video = "VIDEO"

    var capitalized: String {
        return rawValue.capitalized
    }
}

struct PlacementItem: Decodable {
    let type: RowType
    let name: String
    let placementId: Int
    let lineItemId: Int?
    let creativeId: Int?

    var fullName: String {
        if isFull() {
            return "\(placementId) - \(lineItemId!) - \(creativeId!) | (\(name))"
        } else {
            return "\(placementId) | (\(name))"
        }
    }

    func isFull() -> Bool {
        return lineItemId != nil && creativeId != nil
    }
}

class MainViewController: UIViewController {

    private var database: DatabaseReference!
    private var items: [PlacementItem] = []
    private var headerLabel: UILabel!
    private var bannerView: BannerView!
    private var segment: UISegmentedControl!

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "adsTableView"
        view.register(ItemCell.self, forCellReuseIdentifier: "itemCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        BumperPage.overrideName("Demo App")

        initUI()
        configureDataSource()
    }

    func configuration1() {
        bannerView.enableParentalGate()
        bannerView.enableBumperPage()

        InterstitialAd.enableParentalGate()
        InterstitialAd.enableBumperPage()

        VideoAd.enableParentalGate()
        VideoAd.enableBumperPage()
        VideoAd.enableMuteOnStart()

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
        VideoAd.enableCloseButtonWithWarning()
        VideoAd.disableMuteOnStart()

        // Close button configured with no delay
        VideoAd.enableCloseButtonNoDelay()
        InterstitialAd.enableCloseButtonNoDelay()
    }

    private func initUI() {
        initHeader()
        initSegment()
        initBannerView()
        initTable()
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

    private func initTable() {

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bannerView.topAnchor),
            tableView.topAnchor.constraint(equalTo: segment.bottomAnchor)
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

    private func configureDataSource() {

        database = Database.database(url: Constants.firebaseDatabaseURL).reference()

        database.child("list-items").observe(.value) { [weak self] snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }

            self?.items = children.compactMap { snapshot in
                return try? snapshot.data(as: PlacementItem.self)
            }

            self?.tableView.reloadData()
        }
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
                VideoAd.play(placementId, fromVc: self)
            }
        }
    }

    private func handleSingleRowTapped(item: PlacementItem) {
        switch item.type {
        case .banner:
            bannerView.load(item.placementId)
        case .interstitial:
            InterstitialAd.load(item.placementId)
        case .video:
            VideoAd.load(item.placementId)
        }
    }

    private func handleMultiIdRowTapped(item: PlacementItem) {
        guard let lineItemId = item.lineItemId, let creativeId = item.creativeId else { return }

        switch item.type {
        case .banner:
            bannerView.load(
                item.placementId,
                lineItemId: lineItemId,
                creativeId: creativeId
            )
        case .interstitial:
            InterstitialAd.load(
                item.placementId,
                lineItemId: lineItemId,
                creativeId: creativeId
            )
        case .video:
            VideoAd.load(
                item.placementId,
                lineItemId: lineItemId,
                creativeId: creativeId
            )
        }
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell
        else {
            print("Unable to dequeue an ItemCell")
            return UITableViewCell()
        }
        cell.accessibilityIdentifier = item.name
        cell.placementItem = item
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = items[indexPath.row]

        print("\(item.type.capitalized) clicked"
              + " for placement id: \(item.placementId)"
              + " lineItemId: \(String(describing: item.lineItemId))"
              + " creativeId: \(String(describing: item.creativeId))"
        )

        if item.isFull() {
            handleMultiIdRowTapped(item: item)
        } else {
            handleSingleRowTapped(item: item)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
