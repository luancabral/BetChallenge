//
//  UpcomingEventsService.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Alamofire

protocol UpcomingEventsServiceProtocol {
    func fetchUpcomingEvents(completion: @escaping (Result<AllEventsModel, ServiceError>) -> Void)
}

final class UpComingEventsService: ServiceManager, UpcomingEventsServiceProtocol {
    func fetchUpcomingEvents(completion: @escaping (Result<AllEventsModel, ServiceError>) -> Void) {
        fetch(endPoint: UpComingEventsAPI.upComingEvents, dataType: AllEventsModel.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
