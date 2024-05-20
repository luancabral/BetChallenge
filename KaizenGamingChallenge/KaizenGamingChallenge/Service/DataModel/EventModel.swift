//
//  EventModel.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import Foundation
import UIKit

struct EventModel: Codable {
    let eventName, eventId, match: String
    let sportId: Sports
    let startTime: Int
    
    var isFavorite: Bool {
        let defaults = UserDefaultManager()
        return defaults.hasSome(element: eventId)
    }
    
    private enum CodingKeys: String, CodingKey {
        case eventName = "d"
        case eventId = "i"
        case startTime = "tt"
        case sportId = "si"
        case match = "sh"
    }
}

enum Sports: String, Codable {
    case basketball = "BASK"
    case dart = "DART"
    case esports = "ESPS"
    case soccer = "FOOT"
    case futsal = "FUTS"
    case handball = "HAND"
    case hockey = "ICEH"
    case snooker = "SNOO"
    case tableTennis = "TABL"
    case tennis = "TENN"
    case volleyball = "VOLL"
    
    var image: UIImage? {
        switch self {
        case .basketball:
            return UIImage(named: "basketball")
        case .dart:
            return UIImage(named: "dart")
        case .esports:
            return UIImage(named: "esports")
        case .soccer:
            return UIImage(named: "soccer")
        case .futsal:
            return UIImage(named: "fustal")
        case .handball:
            return UIImage(named: "handball")
        case .hockey:
            return UIImage(named: "hockey")
        case .snooker:
            return UIImage(named: "snooker")
        case .tableTennis:
            return UIImage(named: "tableTennis")
        case .tennis:
            return UIImage(named: "tennis")
        case .volleyball:
            return UIImage(named: "volleyball")
        }
    }
}
