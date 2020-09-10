//
//  ViewableDetector.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 10/09/2020.
//

enum ViewableTargetTick: Int {
    case display = 1
    case video = 2
}

protocol ViewableDetectorType {
    func start(for view: UIView, target: ViewableTargetTick, hasBeenVisible: VoidBlock?)
}

class ViewableDetector: ViewableDetectorType {
    private var timer: Timer?
    private let logger: LoggerType
    private weak var view: UIView?
    private var viewableCounter = 0
    private var targetTickCount = 0
    
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
    
    func start(for view: UIView, target: ViewableTargetTick, hasBeenVisible: VoidBlock?) {
        cancel()
        targetTickCount = target.rawValue
        self.hasBeenVisible = hasBeenVisible
        self.view = view
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(timerFunction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerFunction() {
        logger.info("Tick for visibility")
        
        if view?.isVisibleToUser ?? false {
            viewableCounter += 1
            logger.info("View is visible to user: \(viewableCounter)")
        }
        
        if viewableCounter >= targetTickCount {
            logger.success("View has been visible to user. Viewable is completed.")
            hasBeenVisible?()
            cancel()
        }
    }
    
    deinit {
        cancel()
    }
}
