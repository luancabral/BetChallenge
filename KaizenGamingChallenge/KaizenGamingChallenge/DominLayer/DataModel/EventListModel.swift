//
//  EventsListModel.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import Foundation

typealias AllEventsModel = [EventDetailsModel]

struct EventDetailsModel: Codable {
    let sportName: String
    let activeEvents: [EventModel]
    let sportId: Sports
    
    private enum CodingKeys: String, CodingKey {
        case sportName = "d"
        case activeEvents = "e"
        case sportId = "i"
    }
    
    static func makeMock() -> AllEventsModel? {
        return try? JSONModelFactory.makeModel(AllEventsModel.self, fromJSON: "mock")
    }
}



