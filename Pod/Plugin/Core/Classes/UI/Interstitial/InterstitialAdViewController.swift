//
//  InterstitialAdController.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import UIKit

class InterstitialAdViewController: UIViewController, Injectable {
    
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var orientationProvider: OrientationProviderType = dependencies.resolve()
    
    private var bannerView: BannerView?
    private var closeButton: UIButton?
    
    private let adResponse: AdResponse
    private let parentGateEnabled: Bool
    private let bumperPageEnabled: Bool
    private let testingEnabled: Bool
    private let orientation: Orientation
    private let delegate: AdEventCallback?
    
    init(adResponse: AdResponse,
         parentGateEnabled: Bool,
         bumperPageEnabled: Bool,
         testingEnabled: Bool,
         orientation: Orientation,
         delegate: AdEventCallback?) {
        self.adResponse = adResponse
        self.parentGateEnabled = parentGateEnabled
        self.bumperPageEnabled = bumperPageEnabled
        self.testingEnabled = testingEnabled
        self.orientation = orientation
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundGray
        configureBannerView()
        configureCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bannerView?.play()
    }
    
    override var shouldAutorotate: Bool { true }
    
    override var prefersStatusBarHidden: Bool { true }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .fade }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientationProvider.findSupportedOrientations(orientation, super.supportedInterfaceOrientations)
    }
    
    /// Method that is called to close the ad
    func close() {
        bannerView?.close()
        bannerView = nil
        dismiss(animated: true, completion: nil)
    }
    
    private func configureBannerView() {
        let bannerView = BannerView()
        bannerView.configure(adResponse: adResponse, delegate: delegate) { [weak self] in
            self?.closeButton?.isHidden = false
        }
        bannerView.setTestMode(testingEnabled)
        bannerView.setBumperPage(bumperPageEnabled)
        bannerView.setParentalGate(parentGateEnabled)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bannerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        self.bannerView = bannerView
    }
    
    private func configureCloseButton() {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("", for: .normal)
        button.setImage(imageProvider.closeImage, for: .normal)
        button.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40.0),
            button.heightAnchor.constraint(equalToConstant: 40.0),
            button.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0)
        ])
        
        self.closeButton = button
    }
    
    @objc private func onCloseClicked() {
        bannerView?.close()
        dismiss(animated: true)
    }
}
