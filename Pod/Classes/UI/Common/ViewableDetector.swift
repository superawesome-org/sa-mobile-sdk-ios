//
//  ViewableDetector.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 10/09/2020.
//

protocol ViewableDetectorType {
    var whenVisible: VoidBlock? { get set }
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
    var whenVisible: VoidBlock?

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
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self,
                                     selector: #selector(timerFunction), userInfo: nil, repeats: true)
    }

    func start(for view: UIView, forTickCount: Int, hasBeenVisible: VoidBlock?) {
        targetTickCount = forTickCount
        start(for: view, hasBeenVisible: hasBeenVisible)
    }

    @objc private func timerFunction() {

        guard
            let v = view as? VideoPlayer,
            let t = v.getAVPlayer()?.timeControlStatus
        else { return }

        if t == .playing {
            viewableCounter += 1
            whenVisible?()

            print("Heartbeat increased: \(viewableCounter)")
        }

        if viewableCounter >= targetTickCount {
            print("Heartbeat reached target: \(viewableCounter)")
            hasBeenVisible?()
            cancel()
        }
    }

    deinit {
        cancel()
    }
}
