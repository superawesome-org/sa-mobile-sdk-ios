//
//  VastModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/07/2020.
//

class VastAd {
    var url: String?
    var redirect: String?
    var type: VastType = .Invalid
    var media: [VastMedia] = []
    
    private(set) var clickThroughUrl: String?
    
    var errorEvents: [String] = []
    var impressionEvents: [String] = []
    var creativeViewEvents: [String] = []
    var startEvents: [String] = []
    var firstQuartileEvents: [String] = []
    var midPointEvents: [String] = []
    var thirdQuartileEvents: [String] = []
    var completeEvents: [String] = []
    var clickTrackingEvents: [String] = []
    
    func merge(from: VastAd?) -> VastAd {
        guard let from = from else { return self }
        
        self.url = from.url ?? self.url
        self.clickThroughUrl = from.clickThroughUrl ?? self.clickThroughUrl
        self.errorEvents.append(contentsOf: from.errorEvents)
        self.impressionEvents.append(contentsOf: from.impressionEvents)
        self.creativeViewEvents.append(contentsOf: from.creativeViewEvents)
        self.startEvents.append(contentsOf: from.startEvents)
        self.firstQuartileEvents.append(contentsOf: from.firstQuartileEvents)
        self.midPointEvents.append(contentsOf: from.midPointEvents)
        self.thirdQuartileEvents.append(contentsOf: from.thirdQuartileEvents)
        self.completeEvents.append(contentsOf: from.completeEvents)
        self.clickTrackingEvents.append(contentsOf: from.clickTrackingEvents)

        self.media.append(contentsOf: from.media)
        
        return self
    }
    
    func addMedia(_ media: VastMedia) {
        self.media.append(media)
    }
    
    func addEvent(_ event: VastEvent) {
        switch event.event {
        case "vast_click_through": clickThroughUrl = event.url
        case "vast_error": errorEvents.append(event.url)
        case "vast_impression": impressionEvents.append(event.url)
        case "vast_creativeView": creativeViewEvents.append(event.url)
        case "vast_start": startEvents.append(event.url)
        case "vast_firstQuartile": firstQuartileEvents.append(event.url)
        case "vast_midpoint": midPointEvents.append(event.url)
        case "vast_thirdQuartile": thirdQuartileEvents.append(event.url)
        case "vast_complete": completeEvents.append(event.url)
        case "vast_click_tracking": clickTrackingEvents.append(event.url)
        default: break
        }
    }
    
    func sortedMedia() -> [VastMedia] {
        return media.sorted { (first, second) -> Bool in
            first.bitrate ?? 0 < second.bitrate ?? 0
        }
    }
}

enum VastType {
    case Invalid
    case InLine
    case Wrapper
}

struct VastMedia {
    var type: String?
    var url: String?
    var bitrate: Int?
    var width: Int?
    var height: Int?
}

struct VastEvent {
    let event: String
    let url: String
}



