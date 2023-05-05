//
//  MainViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 02/02/2022.
//

import Combine
import SuperAwesome
import UIKit

class MainViewController: UIViewController {
    private let inset: CGFloat = 16.0
    private let settingsButtonSize = CGSize(width: 20.0, height: 20.0)
    private let bannerHeight: CGFloat = 50.0

    private var isPlayImmediatelyEnabled = true
    private var features: Features?
    private var featuresViewModel: FeaturesViewModel!
    private var cancellable: AnyCancellable?
    private var isInTestMode = UITestSetup().isInTestMode

    private var items: [PlacementItem] {
        guard let features else { return [] }
        var placements: [PlacementItem] = []
        features.features.forEach { item in
            placements.append(contentsOf: item.placements)
        }
        return placements
    }
    
    private lazy var debugLogLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.text = ""
        label.isHidden = true
        label.accessibilityIdentifier = "Debug.Labels.Log"
        return label
    }()

    private lazy var headerLabel: UILabel = {
        let version = AwesomeAds.info()?.versionNumber ?? ""
        let label = UILabel()
        label.text = "AwesomeAds.version: \(version)"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        label.accessibilityIdentifier = "AdList.Labels.Version"
        return label
    }()

    private lazy var settingsButton: TappableButton = {
        let button = TappableButton()
        button.accessibilityIdentifier = "AdList.Buttons.Settings"
        button.setImage(UIImage(named: "ico_settings"), for: .normal)
        button.tintColor = .darkGray
        button.onTap = { [weak self] in
            self?.settingsView.show()
        }
        return button
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "AdList.TableView"
        view.register(ItemCell.self, forCellReuseIdentifier: "itemCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var bannerView: BannerView = {
        let bannerView = BannerView()
        bannerView.enableBumperPage()
        bannerView.backgroundColor = UIColor.gray
        bannerView.accessibilityIdentifier = "AdList.BannerView"
        bannerView.setCallback { [weak self] (_, event) in
            guard let strongSelf = self else { return }
            print(" bannerView >> \(event.name())")
            strongSelf.logEventForUITesting(event)
            if event == .adLoaded && self?.isPlayImmediatelyEnabled == true {
                bannerView.play()
            }
        }
        return bannerView
    }()

    private lazy var settingsView: SettingsView = {
        let view = SettingsView(frame: .zero)
        view.delegate = self
        view.accessibilityIdentifier = "SettingsView"
        view.alpha = 0.0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "AdList.Screen"
        BumperPage.overrideName("Demo App")

        initUI()
        
        featuresViewModel = FeaturesViewModel()
        cancellable = featuresViewModel.$features.sink { [weak self] features in
            self?.features = features
            self?.tableView.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancellable?.cancel()
    }

    private func initUI() {
        addSubViews()
        addConstriants()
        configureDebugLogLabel()
        configureVideo()
        configureInterstitial()
        updateSettings(settings: SettingsModel())
    }

    private func addSubViews() {
        view.addSubview(debugLogLabel)
        view.addSubview(headerLabel)
        view.addSubview(settingsButton)
        view.addSubview(tableView)
        view.addSubview(bannerView)
        view.addSubview(settingsView)
    }
    
    private func configureDebugLogLabel() {
        debugLogLabel.isHidden = !isInTestMode
    }

    private func addConstriants() {
        
        debugLogLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: inset)
        debugLogLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: inset)
        debugLogLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: inset)
        
        headerLabel.autoPinEdge(.top, to: .bottom, of: debugLogLabel, withOffset: inset)
        headerLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: inset)
        
        settingsButton.autoPinEdge(.leading, to: .trailing, of: headerLabel, withOffset: inset)
        settingsButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: inset)
        settingsButton.autoAlignAxis(.horizontal, toSameAxisOf: headerLabel)
        settingsButton.autoSetDimensions(to: settingsButtonSize)

        tableView.autoPinEdge(toSuperviewEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(.top, to: .bottom, of: settingsButton, withOffset: inset)

        bannerView.autoPinEdge(.top, to: .bottom, of: tableView)
        bannerView.autoPinEdge(toSuperviewEdge: .leading)
        bannerView.autoPinEdge(toSuperviewEdge: .trailing)
        bannerView.autoPinEdge(toSuperviewSafeArea: .bottom)
        bannerView.autoSetDimension(.height, toSize: bannerHeight)

        settingsView.autoPinEdgesToSuperviewEdges()
    }

    private func configureInterstitial() {
        InterstitialAd.setCallback { [weak self] (placementId, event) in
            guard let strongSelf = self else { return }
            strongSelf.logEventForUITesting(event)
            print(" InterstitialAd >> \(event.name())")
            if event == .adLoaded && strongSelf.isPlayImmediatelyEnabled {
                InterstitialAd.play(placementId, fromVC: strongSelf)
            }
        }
    }

    private func configureVideo() {
        VideoAd.enableCloseButton()
        VideoAd.setCallback { [weak self] (placementId, event) in
            guard let strongSelf = self else { return }
            print("VideoAd >> \(event.name())")
            strongSelf.logEventForUITesting(event)
            if event == .adLoaded && strongSelf.isPlayImmediatelyEnabled {
                VideoAd.play(withPlacementId: placementId, fromVc: strongSelf)
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
            VideoAd.load(withPlacementId: item.placementId)
        }
    }
    
    private func logEventForUITesting(_ event: AdEvent) {
        debugLogLabel.text?.append("\(event.name()) ")
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
                withPlacementId: item.placementId,
                lineItemId: lineItemId,
                creativeId: creativeId
            )
        }
    }
}

// MARK: UITableViewDataSource

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

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = items[indexPath.row]

        print("\(item.type.title.capitalized) clicked"
              + " for placement id: \(item.placementId)"
              + " lineItemId: \(String(describing: item.lineItemId))"
              + " creativeId: \(String(describing: item.creativeId))"
        )

        if item.isFull {
            handleMultiIdRowTapped(item: item)
        } else {
            handleSingleRowTapped(item: item)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    private func updateSettings(settings: SettingsModel) {

        isPlayImmediatelyEnabled = settings.isPlayAdImmediatelyEnabled.value

        // banner

        bannerView.setTestMode(settings.isTestModeEnabled.value)
        bannerView.setBumperPage(settings.isBumperEnabled.value)
        bannerView.setParentalGate(settings.isParentalGateEnabled.value)

        // Interstitial

        InterstitialAd.setTestMode(settings.isTestModeEnabled.value)
        InterstitialAd.setBumperPage(settings.isBumperEnabled.value)
        InterstitialAd.setParentalGate(settings.isParentalGateEnabled.value)

        // Video

        VideoAd.setTestMode(settings.isTestModeEnabled.value)
        VideoAd.setBumperPage(settings.isBumperEnabled.value)
        VideoAd.setParentalGate(settings.isParentalGateEnabled.value)
        VideoAd.setMuteOnStart(settings.isVideoMutedOnStart.value)
        VideoAd.setCloseButtonWarning(settings.isVideoLeaveWarningEnabled.value)
        VideoAd.setCloseAtEnd(settings.isVideoCloseAtEndEnabled.value)

        switch settings.closeButtonMode.value {
        case .hidden:
            VideoAd.disableCloseButton()
        case .visibleImmediately:
            InterstitialAd.enableCloseButtonNoDelay()
            VideoAd.enableCloseButtonNoDelay()
        case .visibleWithDelay:
            InterstitialAd.enableCloseButton()
            VideoAd.enableCloseButton()
        }
    }
}

// MARK: SettingsViewDelegate

extension MainViewController: SettingsViewDelegate {
    func didUpdateSettings(settings: SettingsModel) {
        updateSettings(settings: settings)
    }
}
