//
//  PopJamAdManager.swift
//  Pods
//
//  Created by Mark Gilchrist on 19/07/2021.
//

import Foundation

@objc
public protocol AdManagerDelegate: NSObjectProtocol {
    func adManager(_ adManager: AdManager, didLoadAd ad: PJAd)
    func adManagerDidFailToLoadAd(_ adManager: AdManager)
}

private let cachedAdsKey: String = "AdManagerCachedAdsDataKey"
private let cpiEventSend: String = "adManagerCPIEventSendKey"

@objcMembers
public class AdManager: NSObject, Injectable {

    public static let sharedManager: AdManager = AdManager()

    lazy fileprivate var pCachedAds: [PJAd] = {
        guard let data: Data = UserDefaults.standard.object(forKey: cachedAdsKey) as? Data else { return [] }
        NSKeyedUnarchiver.setClass(PJAd.self, forClassName: "PopJam.PJAd")
        guard let adsArray: [PJAd] = NSKeyedUnarchiver.unarchiveObject(with: data) as? [PJAd] else { return [] }
        return adsArray
    }()

    public var isLoadingAd: Bool = false
    private lazy var network: AwesomeAdsApiDataSourceType = dependencies.resolve()
    private lazy var adLoader: AdRepositoryType = dependencies.resolve()
    private var event: EventQuery?
    private lazy var eventRepo: EventRepositoryType = dependencies.resolve()
    private lazy var numberGenerator: NumberGeneratorType = dependencies.resolve()
    private lazy var adQueryMaker: AdQueryMakerType = dependencies.resolve()
    private lazy var sdkInfo: SdkInfoType = dependencies.resolve()
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    private let factory = RequestFactoryImpl()

    public weak var delegate: AdManagerDelegate?
    public var cachedAds: [PJAd] { get { return pCachedAds } }

    override init() {
        super.init()
        AwesomeAds.initSDK(true)
    }

    /**
     If the PJAd Already exists, remove it from its place and put it on top,
     else just put it on top.
     If the chache has more than 10 feed items, remove the last one.
     
     - parameter ad: The SAAd to cache.
     */
    fileprivate func cacheAd(_ ad: PJAd) {
        if let indexOfItem = pCachedAds.firstIndex(of: ad) {
            pCachedAds.remove(at: indexOfItem)
        }

        pCachedAds.append(ad)

        if pCachedAds.count > 10 {
            pCachedAds.removeLast()
        }

        for ad in pCachedAds {
            if let hoursDifference = self.adTimeCache(ad) {
                if hoursDifference > 12 {
                    if let indexOfItem = pCachedAds.firstIndex(of: ad) {
                        pCachedAds.remove(at: indexOfItem)
                    }
                    self.loadAd()
                }
            }
        }

        ad.dateForPost = Int64(Date().timeIntervalSince1970 * 1000)
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: pCachedAds)
        userDefaults.set(data, forKey: cachedAdsKey)
    }

    fileprivate func adTimeCache(_ ad: PJAd) -> NSInteger! {
        let adDate = NSDate(timeIntervalSince1970: TimeInterval(ad.dateForPost / 1000))
        let now = NSDate()

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour]
        formatter.maximumUnitCount = 2
        let hours = formatter.string(from: adDate as Date, to: now as Date)
        return NSInteger(hours!)
    }

    public func loadAd() {
        // mark start ad loading
        isLoadingAd = true

        // send network request

        adLoader.getAd(placementId: 31570, request: factory.makeRequest(screen: .bannerView, size: UIScreen.main.bounds.size)) { [weak self] result in

            guard let weakSelf = self else {
                return
            }

            // mark stop ad loading
            weakSelf.isLoadingAd = false

            // process:
            switch result {
            case .success(let response):
                guard let pjAd = weakSelf.popJamAdFromSAAd(response) else {
                    weakSelf.delegate?.adManagerDidFailToLoadAd(weakSelf)
                    return
                }
                weakSelf.cacheAd(pjAd)
                weakSelf.delegate?.adManager(weakSelf, didLoadAd: pjAd)
            case .failure: weakSelf.delegate?.adManagerDidFailToLoadAd(weakSelf)
            }
        }
    }

    public func injectAd(_ ad: PJAd) {
        cacheAd(ad)
        delegate?.adManager(self, didLoadAd: ad)
    }

    fileprivate func popJamAdFromSAAd(_ response: AdResponse) -> (PJAd?) {
        guard let payload = response.advert.creative.payload else { return nil }
        let cleanPayload = payload.replacingOccurrences(of: "”", with: "\"").replacingOccurrences(of: "“", with: "\"")
        guard let data: Data = cleanPayload.data(using: String.Encoding.utf8) else { return nil }
        do {
            guard let dictionary: [String: AnyObject] = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyObject] else { return nil }
            guard let feedItemId: String = dictionary["feedItemId"] as? String else { return nil }
            let pjad: PJAd = PJAd(feedItemId: feedItemId)
            event = adQueryMaker.makeClickQuery(response)
            pjad.trackingUrl = "\(response.baseUrl ?? "")/v2/click?placement=\(response.placementId)&line_item=\(response.advert.lineItemId)&creative=\(response.advert.creative.id)"

            pjad.clickUrl = response.advert.creative.clickUrl ?? ""
            pjad.placementId = response.placementId
            pjad.lineItemId = response.advert.lineItemId
            pjad.creativeId = response.advert.creative.id
            guard let customAction: [String: AnyObject] = dictionary["customAction"] as? [String: AnyObject],
                  let type: String = customAction["type"] as? String else {
                pjad.action = .invalid
                return nil
            }

            var dataKey: String = ""
            switch type {
            case "findOutMore":
                pjad.action = .findOutMore
                dataKey = "feedItemId"
            case "follow":
                pjad.action = .follow
                dataKey = "userId"
            case "playRichContent":
                pjad.action = .playRichContent
            case "none":
                pjad.action = .none
            case "appInstall":
                pjad.action = .appInstall
                dataKey = "apple"
            default:
                pjad.action = .invalid
                return nil
            }
            guard let actionData: [String: AnyObject] = customAction["data"] as? [String: AnyObject] else { return pjad }
            print("Action data \(actionData)")
            guard let data: String = actionData[dataKey] as? String, dataKey.count > 0 else { return pjad }
            pjad.data = data

            return pjad
        } catch let error {
            print(error)
            return nil
        }
    }

    public func removeAd(_ ad: PJAd) {
        guard let index = pCachedAds.firstIndex(of: ad) else { return }
        pCachedAds.remove(at: index)
    }

    public func sendCustomEventType(_ eventType: String, ForAd ad: PJAd) {
        // get base url
        let baseURL = "https://ads.superawesome.tv/v2/event/"

        // for the query
        let popJamEventData = PopJamEventData(
            placement: ad.placementId,
            lineItem: ad.lineItemId, creative: ad.creativeId, type: eventType)

        let popJamQuery = PopJamEvent(sdkVersion: sdkInfo.version, data: popJamEventData, rnd: numberGenerator.nextIntForCache())

        // actually send event
        sendEvent(toUrl: baseURL, params: popJamQuery.queryParams)
    }

    public func appLaunched() {
        let userDefaults: UserDefaults = UserDefaults.standard
        guard !userDefaults.bool(forKey: cpiEventSend) else { return }
        let baseURLString: String = "https://ads.superawesome.tv/v2/install"
        guard var components: URLComponents = URLComponents(string: baseURLString) else { return }
        let bundleQueryItem: URLQueryItem = URLQueryItem(name: "bundle", value: Bundle.main.bundleIdentifier ?? "")
        components.queryItems = [bundleQueryItem]
        sendEvent(toUrl: (components.url?.absoluteString)!, params: [:])
        userDefaults.set(true, forKey: cpiEventSend)
        userDefaults.synchronize()
    }

    private func sendEvent(toUrl url: String, params: [String: String]) {
        print("Logger for \(url) sending ...)")
        network.get(endPoint: url, params: params) { result in
            print("Logger for \(url) has Status: \(result)")
        }
    }

}
