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

// todo:
// - remove delegation on MediaControlDelegate | ChromeControlDelegate from VideoViewController
// - have one abstract VideoEvents and two
// - TimedVideoEvents
// - ClickVideoEvents
// that have their own delegates that abstract away the video player ones
// - remove multi-delegation from AwesomeMediaControl cause maybe it won't be needed (maybe)

@objc(SAVideoViewConroller) class VideoViewController: UIViewController, MediaControlDelegate, ChromeControlDelegate {
    
    private var videoPlayer: AwesomeVideoPlayer!
    private var chrome: AdChromeControl!
    
    var events: VideoEventsWithClick!
    var control: MediaControl!
    var showSmallClick: Bool = false
    var showSafeAdLogo: Bool = true
    var showCloseButton: Bool = false
    var shouldCloseAtEnd: Bool = false
    var ad: SAAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preparation
        control.add(delegate: self)
        
        // initial view setup
        view.backgroundColor = UIColor.black
        view.layoutMargins = UIEdgeInsets.zero
        
        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.setControl(control: control)
        videoPlayer.layoutMargins = UIEdgeInsets.zero
        view.addSubview(videoPlayer)
        LayoutUtils.bind(view: videoPlayer, toTheEdgesOf: view)
        
        // setup chrome
        chrome = AdChromeControl(smallClick: showSmallClick,
                                 showCloseButton: showCloseButton,
                                 showSafeAdLogo: showSafeAdLogo)
        chrome.layoutMargins = UIEdgeInsets.zero
        chrome.add(delegate: events)
        chrome.add(delegate: self)
        videoPlayer.setChrome(chrome: chrome)
        LayoutUtils.bind(view: chrome, toTheEdgesOf: videoPlayer)
        
        // play ad
        if let diskUrl = SAUtils.filePath(inDocuments: ad.creative.details.media.path){
            let url = URL(fileURLWithPath: diskUrl)
            control.play(url: url)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // ChromeControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didStartProgressBarSeek()  { /* N/A */ }
    
    func didEndProgressBarSeek(value: Float)  { /* N/A */ }
    
    func didTapPlay()  { /* N/A */ }
    
    func didTapPause()  { /* N/A */ }
    
    func didTapReplay()  { /* N/A */ }
    
    func didTapMaximise()  { /* N/A */ }
    
    func didTapMinimise() { /* N/A */ }
    
    func didTapClose() {
        dismiss(animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MediaControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didCompleteMedia(control: MediaControl, time: Int, duration: Int) {
        chrome.makeCloseButtonVisible()
        control.remove(delegate: self)
        
        if shouldCloseAtEnd {
            chrome.close()
        }
    }
    
    func didError(control: MediaControl, error: Error, time: Int, duration: Int) {
        control.remove(delegate: self)
        chrome.close()
    }
    
    func didPrepare(control: MediaControl, item: AVPlayerItem) { /* N/A */ }
    
    func didUpdateTime(control: MediaControl, time: Int, duration: Int) { /* N/A */ }
    
    func didCompleteSeek(control: MediaControl) { /* N/A */ }
}
