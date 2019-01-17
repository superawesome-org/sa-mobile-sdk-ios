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

@objc(SAVideoViewConroller) class VideoViewController: UIViewController, AdChromeControlDelegate {
    
    private var videoPlayer: AwesomeVideoPlayer!
    private var chrome: AdChromeControl!
    
    var timedVideoEvents: TimedVideoEvents!
    var clickVideoEvents: ClickVideoEvents!
    var control: MediaControl!
    var showSmallClick: Bool = false
    var showSafeAdLogo: Bool = true
    var showCloseButton: Bool = false
    var shouldCloseAtEnd: Bool = false
    var ad: SAAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial view setup
        view.backgroundColor = UIColor.black
        view.layoutMargins = UIEdgeInsets.zero
        
        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.setControl(control: control)
        videoPlayer.layoutMargins = UIEdgeInsets.zero
        timedVideoEvents.setVideoPlayer(player: videoPlayer)
        view.addSubview(videoPlayer)
        LayoutUtils.bind(view: videoPlayer, toTheEdgesOf: view)
        
        // setup chrome
        chrome = AdChromeControl(smallClick: showSmallClick,
                                 showCloseButton: showCloseButton,
                                 showSafeAdLogo: showSafeAdLogo)
        chrome.layoutMargins = UIEdgeInsets.zero
        chrome.set(adDelegate: self)
        videoPlayer.setChrome(chrome: chrome)
        LayoutUtils.bind(view: chrome, toTheEdgesOf: videoPlayer)
        
        // play ad
        if let diskUrl = SAUtils.filePath(inDocuments: ad.creative.details.media.path){
            let url = URL(fileURLWithPath: diskUrl)
            control.play(url: url)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // AdChromeControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didTapOnPadlock() {
        clickVideoEvents.didTapOnPadlock()
    }
    
    func didTapOnSurface() {
        clickVideoEvents.didTapOnSurface()
    }
    
    func didTapOnClose() {
        videoPlayer.destroy()
        SAParentalGate.close()
        dismiss(animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Custom VC methods
    ////////////////////////////////////////////////////////////////////////////
    
    func makeCloseButtonVisible() {
        chrome.makeCloseButtonVisible()
    }
    
    func close() {
        chrome.close()
    }
}
