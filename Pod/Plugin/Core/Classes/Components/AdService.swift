//
//  AdService.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

class AdService: Injectable {
    // Dependencies
    private lazy var adRepository: AdRepositoryType = dependencies.resolve()
    private lazy var eventRepository: EventRepositoryType = dependencies.resolve()
    private lazy var logger: LoggerType = dependencies.resolve(param: AdService.self)
    
    private var delegate: AdEventCallback?
    private var adResponse: AdResponse?
    private var placementId: Int { adResponse?.placementId ?? 0 }
    
    func setCallback(_ callback: @escaping AdEventCallback) { delegate = callback }
    
    func load(_ placementId: Int, request: AdRequest) {
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
        self.adResponse = response
        delegate?(placementId, .adLoaded)
    }
    
    private func onFailure(_ error: Error) {
        logger.error("Ad load failed", error: error)
        delegate?(placementId, .adFailedToLoad)
    }
    
}
