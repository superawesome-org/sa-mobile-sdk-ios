//
//  SAManagedVideoAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 12/01/2022.
//

import UIKit
import WebKit

@objc(SAManagedVideoAdViewController) public final class SAManagedVideoAdViewController: UIViewController, Injectable {
    private let placementId: Int
    private let html: String
    private var closeButton: UIButton?
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    
    init(placementId: Int, html: String) {
        self.placementId = placementId
        self.html = html
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }
    
    lazy var managedBannerAd: SAManagedBannerAd = {
        return SAManagedBannerAd()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        DispatchQueue.main.async {
            self.managedBannerAd.load(placementId: self.placementId, html: self.html)
        }
        
    }
    
    /// Method that is called to close the ad
    func close() {
        managedBannerAd.close()

        dismiss(animated: true, completion: nil)
    }
    
    private func configureCloseButton() {
        let button = UIButton()
        button.isHidden = false
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
        managedBannerAd.close()
        dismiss(animated: true)
    }
    
    private func initView() {
        managedBannerAd.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(managedBannerAd)
        
        NSLayoutConstraint.activate([
            managedBannerAd.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0),
            managedBannerAd.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0),
            managedBannerAd.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0),
            managedBannerAd.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0),
        ])
        
        configureCloseButton()
    }
}
