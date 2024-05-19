//
//  JSONModelFactory.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Foundation

final class JSONModelFactory {
    static func makeModel<T: Codable>(_: T.Type, fromJSON json: String) throws -> T? {
        let bundle = Bundle(for: self)
        guard let filePath = bundle.url(forResource: json, withExtension: "json") else { return nil }
        
        let content = try Data(contentsOf: filePath)
        return try JSONDecoder().decode(T.self, from: content)
        
    }
}
