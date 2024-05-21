//
//  BaseNavigationController.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        updatedTheme()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    private func updatedTheme() {
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .primary
        navigationBar.tintColor = .primary
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
