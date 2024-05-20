//
//  ServiceError.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Foundation

enum ServiceError: Error {
    case network
    case other
    
    var message: String {
        switch self {
        case .network:
            return "We have a network error. We are working to resolve it. Try again in a moment"
        case .other:
            return "Unable to complete. We are working to resolve it. Try again in a moment"
        }
    }
}
