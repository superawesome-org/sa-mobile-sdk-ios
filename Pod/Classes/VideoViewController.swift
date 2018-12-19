//
//  VideoViewController.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit
import SAModelSpace
import SAUtils
import SAParentalGate

@objc(SAVideoViewConroller) class VideoViewController: UIViewController, MediaControlDelegate {
    
    private var tapDelegate: VideoClick!
    private var videoPlayer: AwesomeVideoPlayer!
    private var closeButton: UIButton!
    private var chrome: AdChromeControl!
    
    var ad: SAAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preparation
        VideoAd.control.add(delegate: self)
        
        // initial view setup
        view.backgroundColor = UIColor.black
        view.layoutMargins = UIEdgeInsets.zero
        
        // setup tap delegate
        tapDelegate = VideoClick(events: VideoAd.getVideoEvents().getEvents(),
                                 placementId: ad.placementId,
                                 isParentalGateEnabled: VideoAd.isParentalGateEnabled,
                                 isBumperPageEnabled: VideoAd.isBumperPageEnabled)
        
        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.setControl(control: VideoAd.control)
        videoPlayer.layoutMargins = UIEdgeInsets.zero
        view.addSubview(videoPlayer)
        bind(view: videoPlayer, toTheEdgesOf: view)
        
        // setup chrome
        chrome = AdChromeControl(smallClick: VideoAd.shouldShowSmallClickButton)
        chrome.layoutMargins = UIEdgeInsets.zero
        chrome.addTapDelegate(delegate: tapDelegate)
        videoPlayer.setChrome(chrome: chrome)
        bind(view: chrome, toTheEdgesOf: videoPlayer)
        
        // setup close button
        closeButton = UIButton(frame: .zero)
        closeButton.setImage(SAImageUtils.closeImage(), for: .normal)
        closeButton.isHidden = !VideoAd.shouldShowCloseButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        bind(view: closeButton, toTopRightOf: view)
        
        // play ad
        if let diskUrl = SAUtils.filePath(inDocuments: ad.creative.details.media.path){
            let url = URL(fileURLWithPath: diskUrl)
            VideoAd.control.play(url: url)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // The close method on the View Controller
    ////////////////////////////////////////////////////////////////////////////
    
    @objc private func close() {
        videoPlayer?.destroy()
        SAParentalGate.close()
        dismiss(animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MediaControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didPrepare(control: MediaControl, item: AVPlayerItem) {
        // N/A
    }
    
    func didUpdateTime(control: MediaControl, time: Int, duration: Int) {
        // N/A
    }
    
    func didCompleteMedia(control: MediaControl, time: Int, duration: Int) {
        closeButton.isHidden = false
        control.remove(delegate: self)
        
        if VideoAd.shouldAutomaticallyCloseAtEnd {
            close()
        }
    }
    
    func didCompleteSeek(control: MediaControl) {
        // N/A
    }
    
    func didError(control: MediaControl, error: Error, time: Int, duration: Int) {
        control.remove(delegate: self)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private aux methods
    ////////////////////////////////////////////////////////////////////////////
    
    private func bind(view: UIView, toTheEdgesOf otherView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let margins = otherView.layoutMarginsGuide
        
        view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
        view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8.0).isActive = true
    }
    
    private func bind(view: UIView, toTopRightOf otherView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let margins = otherView.layoutMarginsGuide
        
        view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
        view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
}
