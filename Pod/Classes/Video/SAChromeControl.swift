//
//  SAChromeControl.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit
import SAVideoPlayer

class SAChromeControl: UIView, ChromeControl {
    
    private var blackMask: SABlackMask!
    private var chrono: SACronograph!
    private var clicker: SAURLClicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    private func initSubViews() {
        blackMask = SABlackMask()
        addSubview(blackMask)
        chrono = SACronograph()
        addSubview(chrono)
        clicker = SAURLClicker()
        addSubview(clicker)
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
        chrono.setTime(ramaining)
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
