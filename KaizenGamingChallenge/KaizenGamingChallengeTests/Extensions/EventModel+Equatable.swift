//
//  EventModel+Equatable.swift
//  KaizenGamingChallengeTests
//
//  Created by Luan Cabral on 20/05/24.
//

import Foundation
@testable import KaizenGamingChallenge

extension EventModel: Equatable {
    public static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        return lhs.eventName == rhs.eventName &&
        lhs.eventId == rhs.eventId &&
        lhs.match == rhs.match &&
        lhs.startTime == rhs.startTime &&
        lhs.sportId == rhs.sportId &&
        lhs.isFavorite == rhs.isFavorite
    }
}
