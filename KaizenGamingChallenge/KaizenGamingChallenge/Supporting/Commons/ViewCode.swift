//
//  ViewCode.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import Foundation

protocol ViewCode {
    func buildHierarchy()
    func buildConstratins()
    func setupView()
}

extension ViewCode {
    func setupView() {
        buildHierarchy()
        buildConstratins()
    }
}
