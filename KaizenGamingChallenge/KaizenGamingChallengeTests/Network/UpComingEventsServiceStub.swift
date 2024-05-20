//
//  UpComingEventsServiceStub.swift
//  KaizenGamingChallengeTests
//
//  Created by Luan Cabral on 20/05/24.
//

import Foundation
@testable import KaizenGamingChallenge

final class UpComingEventsServiceStub: UpcomingEventsServiceProtocol {
    var fetchUpcomingEventsResult: Result<AllEventsModel, ServiceError> = .failure(.other)
    
    func fetchUpcomingEvents(completion: @escaping (Result<AllEventsModel, ServiceError>) -> Void) {
        completion(fetchUpcomingEventsResult)
    }
}
