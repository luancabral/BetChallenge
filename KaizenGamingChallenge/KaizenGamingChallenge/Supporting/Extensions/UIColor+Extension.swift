//
//  UIColor+Extension.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 17/05/24.
//

import Foundation
import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    static var primary: UIColor {
        .init(red: 29, green: 32, blue: 37)
    }
    
    static var secondary: UIColor {
        .init(red: 36, green: 43, blue: 53)
    }
}
