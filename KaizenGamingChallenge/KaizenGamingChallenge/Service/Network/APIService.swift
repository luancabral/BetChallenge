//
//  APIService.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Foundation
import Alamofire

enum UpComingEventsAPI {
    case upComingEvents
}

extension UpComingEventsAPI: APIConfiguration {
    var method: HTTPMethod {
        switch self {
        case .upComingEvents:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .upComingEvents:
            return "api/sports"
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = "https://618d3aa7fe09aa001744060a.mockapi.io/" + path
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
