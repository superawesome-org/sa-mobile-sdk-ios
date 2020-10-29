//
//  ClickHandler.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/09/2020.
//

protocol AdControllerType {
    var parentalGateEnabled: Bool { get set }
    var bumperPageEnabled: Bool { get set }
    var testEnabled: Bool { get set }
    var moatLimiting: Bool { get set }
    var closed: Bool { get set }
    var showPadlock: Bool { get }
    var delegate: AdEventCallback? { get set }
    var adResponse: AdResponse? { get set }
    var filePathUrl: URL? { get }
    var adAvailable: Bool { get }
    
    func handleAdTapForVast()
    func handleAdTap(url: URL)
    func handleSafeAdTap()
    
    func onAdClicked(_ url: URL)
    
    func load(_ placementId: Int, _ request: AdRequest)
    func close()
    
    // delegate events
    func adEnded()
    func adFailedToShow()
    func adShown()
    func adClicked()
    func adClosed()
    
    // trigger web events
    func triggerViewableImpression()
    func triggerImpressionEvent()
}

class AdController: AdControllerType, Injectable {    
    private lazy var logger: LoggerType = dependencies.resolve(param: AdController.self)
    private lazy var eventRepository: EventRepositoryType = dependencies.resolve()
    private lazy var adRepository: AdRepositoryType = dependencies.resolve()
    
    private var parentalGate: ParentalGate?
    private var lastClickTime: TimeInterval = 0
    
    var parentalGateEnabled: Bool = false
    var bumperPageEnabled: Bool = false
    var testEnabled = false
    var moatLimiting = true
    var closed = false
    var adResponse: AdResponse?
    var delegate: AdEventCallback?
    var placementId: Int { adResponse?.placementId ?? 0 }
    var showPadlock: Bool { adResponse?.ad.show_padlock ?? false }
    var adAvailable: Bool { adResponse != nil }
    
    private lazy var parentalGateOpenAction = { [weak self] in
        guard let adResponse = self?.adResponse else { return }
        self?.eventRepository.parentalGateOpen(adResponse, completion: nil)
    }
    
    private lazy var parentalGateCancelAction = { [weak self] in
        guard let adResponse = self?.adResponse else { return }
        self?.eventRepository.parentalGateClose(adResponse, completion: nil)
    }
    
    private lazy var parentalGateSuccessAction = { [weak self] in
        guard let adResponse = self?.adResponse else { return }
        self?.eventRepository.parentalGateSuccess(adResponse, completion: nil)
    }
    
    private lazy var parentalGateFailAction = { [weak self] in
        guard let adResponse = self?.adResponse else { return }
        self?.eventRepository.parentalGateFail(adResponse, completion: nil)
    }
    
    var filePathUrl: URL? {
        guard let filePath = adResponse?.filePath else { return nil }
        return URL(fileURLWithPath:filePath)
    }
    
    func close() {
        delegate?(placementId, .adClosed)
        adResponse = nil
        closed = true
    }
    
    func adFailedToShow() { delegate?(placementId, .adFailedToShow) }
    
    func adShown() { delegate?(placementId, .adShown) }
    
    func adEnded() { delegate?(placementId, .adEnded) }
    
    func adClicked() { delegate?(placementId, .adClicked) }
    
    func adClosed() { delegate?(placementId, .adClosed) }
    
    func triggerViewableImpression() {
        guard let adResponse = adResponse else { return }
        eventRepository.viewableImpression(adResponse, completion: nil)
    }
    
    func triggerImpressionEvent() {
        guard let adResponse = adResponse else { return }
        eventRepository.impression(adResponse, completion: nil)
    }
    
    func load(_ placementId: Int, _ request: AdRequest) {
        adRepository.getAd(placementId: placementId,
                           request: request) { [weak self] result in
                            switch result {
                            case .success(let response): self?.onSuccess(response)
                            case .failure(let error): self?.onFailure(error)
                            }
                            
        }
    }
    
    private func onSuccess(_ response: AdResponse) {
        logger.success("Ad load successful for \(response.placementId)")
        adResponse = response
        delegate?(placementId, .adLoaded)
    }
    
    private func onFailure(_ error: Error) {
        logger.error("Ad load failed", error: error)
        delegate?(placementId, .adFailedToLoad)
    }
    
    /// Method that is called when a user clicks / taps on an ad
    func onAdClicked(_ url: URL) {
        logger.success("onAdClicked: for url: \(url.absoluteString)")
        
        if bumperPageEnabled || adResponse?.ad.creative.bumper ?? false {
            BumperPage().play { [weak self] in
                self?.navigateToUrl(url)
            }
        } else {
            navigateToUrl(url)
        }
    }
    
    func navigateToUrl(_ url: URL) {
        guard let adResponse = adResponse else { return }
        
        let currentTime = NSDate().timeIntervalSince1970
        let diff = abs(currentTime - lastClickTime)
        
        if Int32(diff) < Constants.defaultClickThresholdInMs {
            logger.info("Ad clicked too quickly: ignored")
            return
        }
        
        lastClickTime = currentTime
        
        delegate?(placementId, .adClicked)
        
        if adResponse.ad.creative.format == .video {
            eventRepository.videoClick(adResponse, completion: nil)
        } else {
            eventRepository.click(adResponse, completion: nil)
        }
        
        UIApplication.shared.open( url, options: [:], completionHandler: nil)
    }
    
    func handleAdTapForVast() {
        guard let clickThroughUrl = adResponse?.vast?.clickThroughUrl, let url = URL(string: clickThroughUrl) else {
            logger.info("Click through URL is not found")
            return
        }
        
        handleAdTap(url: url)
    }
    
    func handleAdTap(url: URL) {
        showParentalGateIfNeeded { [weak self] in
            self?.onAdClicked(url)
        }
    }
    
    func handleSafeAdTap() {
        showParentalGateIfNeeded(showSuperAwesomeWebPageInSafari)
    }
    
    func showParentalGateIfNeeded(_ completion: VoidBlock?) {
        if parentalGateEnabled {
            parentalGate?.stop()
            parentalGate = dependencies.resolve() as ParentalGate
            parentalGate?.openAction = parentalGateOpenAction
            parentalGate?.cancelAction = parentalGateCancelAction
            parentalGate?.successAction = {
                self.parentalGateSuccessAction()
                completion?()
            }
            parentalGate?.failAction = parentalGateFailAction
            parentalGate?.show()
        } else {
            completion?()
        }
    }
    
    func showSuperAwesomeWebPageInSafari() {
        let onComplete = {
            if let url = URL(string: Constants.defaultSafeAdUrl) {
                UIApplication.shared.open( url, options: [:], completionHandler: nil)
            }
        }
        
        if bumperPageEnabled {
            BumperPage().play(onComplete)
        } else {
            onComplete()
        }
    }
}
