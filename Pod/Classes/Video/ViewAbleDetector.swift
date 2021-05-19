//
//  ViewAbleDetector.swift
//  SuperAwesome
//
//  Created by Mark on 19/05/2021.
//

import Foundation

typealias VoidBlock = () -> Void

protocol ViewableDetectorType {
    func start(for view: UIView, forTickCount: Int, hasBeenVisible: VoidBlock?)
    func start(for view: UIView, hasBeenVisible: VoidBlock?)
    func cancel()
}

class ViewableDetector: ViewableDetectorType {

    private var timer: Timer?

    private weak var view: UIView?
    private var viewableCounter = 0
    private var targetTickCount = 1

    var hasBeenVisible: VoidBlock?

   
    func cancel() {
        viewableCounter = 0
        timer?.invalidate()
        timer = nil
        view = nil
    }
    
    func start(for view: UIView, hasBeenVisible: VoidBlock?) {
        cancel()
        self.hasBeenVisible = hasBeenVisible
        self.view = view
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(timerFunction), userInfo: nil, repeats: true)
    }

    func start(for view: UIView, forTickCount: Int, hasBeenVisible: VoidBlock?) {
        targetTickCount = forTickCount
        start(for: view, hasBeenVisible: hasBeenVisible)
    }

    @objc private func timerFunction() {
        if view?.isVisibleToUser ?? false {
            viewableCounter += 1
        }
        if viewableCounter >= targetTickCount {
            hasBeenVisible?()
            cancel()
        }
    }
    deinit {
        cancel()
    }
}


extension UIView {

    /// Checks to see if the `View` is visible to the user
    var isVisibleToUser: Bool {
        if isHidden || superview == nil { return false }

        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }

        let viewFrame = convert(bounds, to: rootViewController.view)

        return viewFrame.minX >= 0 &&
            viewFrame.maxX <= rootViewController.view.bounds.width &&
            viewFrame.minY >= 0 &&
            viewFrame.maxY <= rootViewController.view.bounds.height
    }
}
