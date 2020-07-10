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
    var medias: [VastMedia] = []
    
    func merge(from: VastAd?) -> VastAd {
        guard let from = from else { return self }
        
        self.url = from.url ?? self.url
        self.events.append(contentsOf: from.events)
        self.medias.append(contentsOf: from.medias)
        
        return self
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



