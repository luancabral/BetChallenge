//
//  UpComingEventsServiceDummy.swift
//  KaizenGamingChallengeTests
//
//  Created by Luan Cabral on 20/05/24.
//

import Foundation
@testable import KaizenGamingChallenge

final class UpComingEventsServiceDummy: UpcomingEventsServiceProtocol {
    func fetchUpcomingEvents(completion: @escaping (Result<AllEventsModel, ServiceError>) -> Void) {
        //Dummy Method
    }
}
