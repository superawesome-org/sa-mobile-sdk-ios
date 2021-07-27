//
//  PJAd.swift
//  Pods
//
//  Created by Mark on 19/07/2021.
//
import Foundation


@objc
public class PJAd: NSObject, NSCoding {

    @objc
    public enum PJAdAction: Int {
        case invalid = -1
        case none
        case findOutMore
        case follow
        case playRichContent
        case appInstall

        public init (withType type: String) {
            switch type {
            case "findOutMore":
                self = .findOutMore
            case "follow":
                self = .follow
            case "playRichContent":
                self = .playRichContent
            case "none":
                self = .none
            case "appInstall":
                self = .appInstall
            default:
                self = .invalid
            }
        }

        public var data: String? {
            switch self {
            case .findOutMore:
                return "feedItemId"
            case .follow:
                return "userId"
            case .appInstall:
                return "apple"
            default:
                return nil
            }
        }
    }
    @objc
    public var action: PJAdAction = .none
    @objc
    public var feedItemId: String
    @objc
    public var data: String?
    @objc
    public var dateForPost: Int64 = 0
    @objc
    public var placementId: Int = 0
    @objc
    public var lineItemId: Int = 0
    @objc
    public var creativeId: Int = 0
    @objc
    public var trackingUrl: String = ""
    @objc
    public var clickUrl: String = ""

    public required init(feedItemId: String)
    {
        self.feedItemId = feedItemId
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        guard let itemId = aDecoder.decodeObject(forKey: "feedItemId") as? String else { return nil }
        self.feedItemId = itemId
        self.action = PJAdAction(rawValue: aDecoder.decodeInteger(forKey: "action")) ?? .none
        self.data = aDecoder.decodeObject(forKey: "data") as? String
        self.dateForPost = aDecoder.decodeInt64(forKey: "dateForPost")
        self.placementId = aDecoder.decodeInteger(forKey: "placementId")
        self.lineItemId = aDecoder.decodeInteger(forKey: "lineItemId")
        self.creativeId = aDecoder.decodeInteger(forKey: "creativeId")
        self.trackingUrl = aDecoder.decodeObject(forKey: "trackingUrl") as? String ?? ""
        self.clickUrl = aDecoder.decodeObject(forKey: "clickUrl") as? String ?? ""
    }

    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(feedItemId, forKey: "feedItemId")
        aCoder.encode(data, forKey: "data")
        aCoder.encode(action.rawValue , forKey: "action")
        aCoder.encode(dateForPost, forKey: "dateForPost")
        aCoder.encode(placementId, forKey: "placementId")
        aCoder.encode(lineItemId, forKey: "lineItemId")
        aCoder.encode(creativeId, forKey: "creativeId")
        aCoder.encode(trackingUrl, forKey: "trackingUrl")
        aCoder.encode(clickUrl, forKey: "clickUrl")
    }

    public override var hash: Int {
        return feedItemId.hash
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let objectToCompareWith: PJAd = object as? PJAd else { return false }
        if objectToCompareWith.feedItemId == feedItemId {return true }
        return false
    }

}
