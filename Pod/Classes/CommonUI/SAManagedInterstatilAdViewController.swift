//
//  SAManagedInterstatilAdViewController.swift
//  SuperAwesome
//
//  Created by Mark on 12/04/2021.
//

import UIKit

class SAManagedInterstatilAdViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var managedBannerAdView: SAManagedBannerAd!

    var placementId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.setImage(SAImageUtils.closeImage(), for: .normal)
        managedBannerAdView.load(placementId: placementId)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc(load:) public func load(placementId: Int) {
        managedBannerAdView.load(placementId: placementId)
    }

    @objc(setCallback:) public func setCallback(value: sacallback? = nil) {
        managedBannerAdView.setCallback(value: value)
    }

    @objc public func setColor(value: Bool) {
        managedBannerAdView.setColor(value: value)
    }

    @objc public func setConfigurationProduction() {
        managedBannerAdView.setConfigurationProduction()
    }

    @objc public func setConfigurationStaging() {
        managedBannerAdView.setConfigurationStaging()
    }

    @objc public func enableTestMode() {
        managedBannerAdView.enableTestMode()
    }

    @objc public func disableTestMode() {
        managedBannerAdView.disableTestMode()
    }

    @objc public func enableMoatLimiting() {
        managedBannerAdView.enableMoatLimiting()
    }

    @objc public func disableMoatLimiting() {
        managedBannerAdView.disableMoatLimiting()
    }

    @objc public func enableBumperPage() {
        managedBannerAdView.enableBumperPage()
    }

    @objc public func disableBumperPage() {
        managedBannerAdView.disableBumperPage()
    }

    @objc public func enableParentalGate() {
        managedBannerAdView.enableParentalGate()
    }

    @objc public func disableParentalGate() {
        managedBannerAdView.disableParentalGate()
    }

    public static func load(placementId: Int, from: UINavigationController) {
        // prepare vc
        let newVC = SAManagedInterstatilAdViewController()
        newVC.placementId = placementId
        from.modalPresentationStyle = .overCurrentContext
        from.present(newVC, animated: true)
    }
}
