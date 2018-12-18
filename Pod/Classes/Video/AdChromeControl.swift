//
//  SAChromeControl.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit
import SAVideoPlayer

@objc(SAAdChromeControlDelegate) protocol AdChromeControlDelegate {
    @objc func didTapOnPadlock()
    @objc func didTapOnSurface()
}

@objc(SAAdChromeControl) class AdChromeControl: UIView, ChromeControl {
    
    private var blackMask: BlackMask!
    private var chrono: Chronograph!
    private var clicker: URLClicker!
    private var padlock: Padlock!
    
    private var delegate: AdChromeControlDelegate? = nil
    
    @objc(initWithSmallClick:)
    init(smallClick: Bool) {
        super.init(frame: .zero)
        initSubViews(smallClick)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews(false)
    }
    
    private func initSubViews(_ smallClick: Bool) {
        alpha = 0.75
        
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
        
        padlock = Padlock()
        padlock.addTarget(self, action: #selector(didTapOnPadlock), for: .touchUpInside)
        addSubview(padlock)
        
        padlock.translatesAutoresizingMaskIntoConstraints = false
        padlock.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
        padlock.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        padlock.widthAnchor.constraint(equalToConstant: 67.0).isActive = true
        padlock.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Setters for custom delegation
    ////////////////////////////////////////////////////////////////////////////
    
    @objc(addTapDelegate:)
    public func addTapDelegate(delegate: AdChromeControlDelegate) {
        self.delegate = delegate
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private tap functions
    ////////////////////////////////////////////////////////////////////////////
    
    @objc private func didTapOnPadlock() {
        delegate?.didTapOnPadlock()
    }
    
    @objc private func didTapOnUrl() {
        delegate?.didTapOnSurface()
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // ChromeControl
    ////////////////////////////////////////////////////////////////////////////
    
    func setPlaying() {
        // N/A
    }
    
    func setPaused() {
        // N/A
    }
    
    func setCompleted() {
        // N/A
    }
    
    func setError(error: Error) {
        // N/A
    }
    
    func setTime(time: Int, duration: Int) {
        let ramaining = duration - time
        chrono.setTime(remaining: ramaining)
    }
    
    func isPlaying() -> Bool {
        return true
    }
    
    func show() {
        // N/A
    }
    
    func hide() {
        // N/A
    }
    
    func setMinimised() {
        // N/A
    }
    
    func setMaximised() {
        // N/A
    }
    
    func isMaximised() -> Bool {
        return false
    }
    
    func close() {
        // N/A
    }
    
    func add(delegate: ChromeControlDelegate) {
        // N/A
    }
    
    func remove(delegate: ChromeControlDelegate) {
        // N/A
    }
}
