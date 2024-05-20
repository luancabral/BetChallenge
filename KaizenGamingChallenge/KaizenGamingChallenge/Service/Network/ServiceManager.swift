//
//  ServiceManager.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Foundation
import Alamofire

class ServiceManager {
    func fetch<T: Decodable>(endPoint: APIConfiguration, dataType: T.Type, completion: @escaping (Result<T, ServiceError>) -> Void) {
        AF.request(endPoint).responseDecodable { (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success(let content):
                completion(.success(content))
            case .failure(let error):
                completion(.failure(self.handleError(error: error)))
            }
        }
    }
    
    private func handleError(error: AFError) -> ServiceError {
        switch error {
        case .sessionTaskFailed: return .network
        default: return .other
        }
    }
}
