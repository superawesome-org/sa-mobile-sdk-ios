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
    var events: [VastEvent] = []
    var media: [VastMedia] = []
    
    func merge(from: VastAd?) -> VastAd {
        guard let from = from else { return self }
        
        self.url = from.url ?? self.url
        self.events.append(contentsOf: from.events)
        self.media.append(contentsOf: from.media)
        
        return self
    }
    
    func addMedia(_ media: VastMedia) {
        self.media.append(media)
    }
    
    func addEvent(_ event: VastEvent) {
        self.events.append(event)
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



