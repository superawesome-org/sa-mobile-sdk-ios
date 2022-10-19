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
    var callback: AdEventCallback? { get set }
    var adResponse: AdResponse? { get set }
    var filePathUrl: URL? { get }
    var adAvailable: Bool { get }

    func handleAdTapForVast()
    func handleAdTap(url: URL)
    func handleSafeAdTap()

    func load(_ placementId: Int, _ request: AdRequest)
    func load(_ placementId: Int, lineItemId: Int, creativeId: Int, _ request: AdRequest)
    func close()

    // delegate events
    func adEnded()
    func adFailedToShow()
    func adShown()
    func adClosed()

    // trigger web events
    func triggerViewableImpression()
    func triggerImpressionEvent()
    func triggerDwellTime()
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
    var callback: AdEventCallback?
    var placementId: Int { adResponse?.placementId ?? 0 }
    var showPadlock: Bool { adResponse?.advert.showPadlock ?? false && adResponse?.advert.ksfRequest == nil }
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
        return URL(fileURLWithPath: filePath)
    }

    func close() {
        callback?(placementId, .adClosed)
        logger.info("Event callback: adClosed for placement \(placementId)")
        adResponse = nil
        closed = true
    }

    func adFailedToShow() {
        callback?(placementId, .adFailedToShow)
        logger.info("Event callback: adFailedToShow for placement \(placementId)")
    }

    func adShown() {
        callback?(placementId, .adShown)
        logger.info("Event callback: adShown for placement \(placementId)")
    }

    func adEnded() {
        callback?(placementId, .adEnded)
        logger.info("Event callback: adEnded for placement \(placementId)")
    }

    func adClosed() {
        callback?(placementId, .adClosed)
        logger.info("Event callback: adClosed for placement \(placementId)")
    }

    func triggerViewableImpression() {
        guard let adResponse = adResponse else { return }
        eventRepository.viewableImpression(adResponse, completion: nil)
        logger.info("Event callback: viewableImpression for placement \(placementId)")
    }

    func triggerImpressionEvent() {
        guard let adResponse = adResponse else { return }
        eventRepository.impression(adResponse, completion: nil)
        logger.info("Event callback: impression for placement \(placementId)")
    }

    func triggerDwellTime() {
        guard let adResponse = adResponse else { return }
        eventRepository.dwellTime(adResponse, completion: nil)
        logger.info("Event callback: dwellTime for placement \(placementId)")
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

    func load(_ placementId: Int, lineItemId: Int, creativeId: Int, _ request: AdRequest) {

        adRepository.getAd(
            placementId: placementId,
            lineItemId: lineItemId,
            creativeId: creativeId,
            request: request) { [weak self] result in
                switch result {
                case .success(let response): self?.onSuccess(response)
                case .failure(let error): self?.onFailure(error)
                }
            }
    }

    private func onSuccess(_ response: AdResponse) {
        adResponse = response
        callback?(placementId, .adLoaded)
        logger.success("Event callback: adLoaded for \(response.placementId)")
    }

    private func onFailure(_ error: Error) {
        logger.error("Event callback: adFailedToLoad for \(placementId)", error: error)
        callback?(placementId, .adFailedToLoad)
    }

    /// Shows bumper screen if needed
    private func showBumperIfNeeded(_ url: URL) {
        if bumperPageEnabled || adResponse?.advert.creative.bumper ?? false {
            BumperPage().play { [weak self] in
                self?.navigateToUrl(url)
            }
        } else {
            navigateToUrl(url)
        }
    }

    private func navigateToUrl(_ url: URL) {
        guard let adResponse = adResponse else { return }

        let currentTime = NSDate().timeIntervalSince1970
        let diff = abs(currentTime - lastClickTime)

        if Int32(diff) < Constants.defaultClickThresholdInSecs {
            logger.info("Event callback: Ad clicked too quickly: ignored")
            return
        }

        lastClickTime = currentTime

        callback?(placementId, .adClicked)
        logger.success("Event callback: adClicked for \(placementId)")

        if adResponse.advert.creative.format == .video {
            eventRepository.videoClick(adResponse, completion: nil)
        } else {
            eventRepository.click(adResponse, completion: nil)
        }

        UIApplication.shared.open( url, options: [:], completionHandler: nil)
    }

    func handleAdTapForVast() {
        logger.info("Event callback: adClicked for placement \(placementId)")

        guard let clickThroughUrl = adResponse?.vast?.clickThroughUrl, let url = URL(string: clickThroughUrl) else {
            logger.info("Event callback: Click through URL is not found")
            return
        }

        handleAdTap(url: url)
    }

    func handleAdTap(url: URL) {
        showParentalGateIfNeeded { [weak self] in
            self?.showBumperIfNeeded(url)
        }
    }

    func handleSafeAdTap() {
        showParentalGateIfNeeded(showSuperAwesomeWebPageInSafari)
    }

    private func showParentalGateIfNeeded(_ completion: VoidBlock?) {
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

    private func showSuperAwesomeWebPageInSafari() {
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
