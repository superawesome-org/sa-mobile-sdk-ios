//
//  ViewableDetector.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 10/09/2020.
//

protocol ViewableDetectorType {
    func start(for view: UIView, forTickCount: Int, hasBeenVisible: VoidBlock?)
    func start(for view: UIView, hasBeenVisible: VoidBlock?)
    func cancel()
}

class ViewableDetector: ViewableDetectorType {

    private var timer: Timer?
    private let logger: LoggerType
    private weak var view: UIView?
    private var viewableCounter = 0
    private var targetTickCount = 1

    var hasBeenVisible: VoidBlock?

    init(logger: LoggerType) {
        self.logger = logger
    }

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
        logger.info("Tick for visibility")

        if view?.isVisibleToUser ?? false {
            viewableCounter += 1
            logger.info("View is visible to user. Ticks: \(viewableCounter)")
        } else {
            logger.info("View is not visible \(String(describing: view.self))")
        }

        if viewableCounter >= targetTickCount {
            logger.success("View has been visible to user. Viewable event is sent.")
            hasBeenVisible?()
            cancel()
        }
    }

    deinit {
        cancel()
    }
}
