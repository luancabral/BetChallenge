//
//  UserDefaultManager.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import Foundation

final class UserDefaultManager {
    private let defaults = UserDefaults.standard
    private let favKey = "favoriteEvents"
    
    func save(items: [String]) {
        defaults.set(items, forKey: favKey)
    }
    
    func load() -> [String]? {
        return defaults.array(forKey: favKey) as? [String]
    }
    
    func update(with newElement: String) {
        var aux = [String]()
        if let savedContent = defaults.array(forKey: favKey) as? [String] {
            aux = savedContent
        }
        aux.append(newElement)
        save(items: aux)
    }
    
    func remove(an element: String) {
        guard let savedContent = load() else { return }
        var aux = [String]()
        aux = savedContent.filter { $0 != element}
        save(items: aux)
    }
    
    func hasSome(element: String) -> Bool {
        guard let savedContent = load() else { return false }
        return savedContent.contains(element)
    }
}
