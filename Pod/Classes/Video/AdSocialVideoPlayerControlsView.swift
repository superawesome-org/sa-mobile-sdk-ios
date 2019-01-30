//
//  SAChromeControl.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit
import SAVideoPlayer

@objc(SAAdSocialVideoPlayerControlsView) public class AdSocialVideoPlayerControlsView: UIView, VideoPlayerControlsView {
    
    private var blackMask: BlackMask!
    private var chrono: Chronograph!
    private var clicker: URLClicker!
    private var padlock: Padlock!
    private var closeButton: CloseButton!
    
    private var padlockAction: (() -> Void)? = nil
    private var closeAction: (() -> Void)? = nil
    private var clickAction: (() -> Void)? = nil
    
    @objc(initWithSmallClick:andShowCloseButton:andShowSafeAdLogo:)
    init(smallClick: Bool, showCloseButton: Bool, showSafeAdLogo: Bool) {
        super.init(frame: .zero)
        initSubViews(smallClick, showCloseButton, showSafeAdLogo)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews(false, true, true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews(false, true, true)
    }
    
    private func initSubViews(_ smallClick: Bool,
                              _ showCloseButton: Bool,
                              _ showSafeAdLogo: Bool) {
        
        blackMask = BlackMask()
        addSubview(blackMask)
        
        let margins = layoutMarginsGuide
        
        blackMask.translatesAutoresizingMaskIntoConstraints = false
        blackMask.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        blackMask.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        blackMask.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8.0).isActive = true
        blackMask.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/5).isActive = true
        
        chrono = Chronograph()
        addSubview(chrono)
        
        chrono.translatesAutoresizingMaskIntoConstraints = false
        chrono.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 8.0).isActive = true
        chrono.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
        chrono.widthAnchor.constraint(equalToConstant: 50).isActive = true
        chrono.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        clicker = URLClicker(smallClick: smallClick)
        addSubview(clicker)
        
        clicker.translatesAutoresizingMaskIntoConstraints = false
        clicker.addTarget(self, action: #selector(didTapOnUrl), for: .touchUpInside)
        
        if !smallClick {
            clicker.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
            clicker.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
            clicker.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
            clicker.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8.0).isActive = true
        }
        else {
            clicker.leadingAnchor.constraint(equalTo: chrono.trailingAnchor, constant: 8.0).isActive = true
            clicker.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
            clicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
            clicker.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        if showSafeAdLogo {
            padlock = Padlock()
            padlock.addTarget(self, action: #selector(didTapOnPadlock), for: .touchUpInside)
            addSubview(padlock)
            
            padlock.translatesAutoresizingMaskIntoConstraints = false
            padlock.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
            padlock.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
            padlock.widthAnchor.constraint(equalToConstant: 67.0).isActive = true
            padlock.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        }
        
        closeButton = CloseButton()
        closeButton.isHidden = !showCloseButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        addSubview(closeButton)
        LayoutUtils.bind(view: closeButton, toTopRightOf: self)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // custom methods
    ////////////////////////////////////////////////////////////////////////////
    
    @objc(makeCloseButtonVisible)
    public func makeCloseButtonVisible() {
        self.closeButton.isHidden = false
    }
    
    public func setPadlockAction(action: @escaping () -> Void) {
        padlockAction = action
    }
    
    public func setClickAction(action: @escaping () -> Void) {
        clickAction = action
    }
    
    public func setCloseAction(action: @escaping () -> Void) {
        closeAction = action
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private tap functions
    ////////////////////////////////////////////////////////////////////////////
    
    @objc
    private func didTapOnPadlock() {
        padlockAction?()
    }
    
    @objc
    private func didTapOnUrl() {
        clickAction?()
    }
    
    @objc
    func close() {
        closeAction?()
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // ChromeControl
    ////////////////////////////////////////////////////////////////////////////
    
    public func setPlaying() { /* N/A */ }
    
    public func setPaused() { /* N/A */ }
    
    public func setCompleted() { /* N/A */ }
    
    public func setError(error: Error) { /* N/A */ }
    
    public func setTime(time: Int, duration: Int) {
        let ramaining = duration - time
        chrono.setTime(remaining: ramaining)
    }
    
    public func isPlaying() -> Bool {
        return true
    }
    
    public func show() { /* N/A */ }
    
    public func hide() { /* N/A */ }
    
    public func setMinimised() { /* N/A */ }
    
    public func setMaximised() { /* N/A */ }
    
    public func isMaximised() -> Bool {
        return false
    }
    
    @objc(setDelegate:)
    public func set(delegate: VideoPlayerControlsViewDelegate) { /* N/A */ }
}
