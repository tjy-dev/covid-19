//
//  Colors.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2020/03/05.
//  Copyright © 2020 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var background: UIColor {
        get {
            .init(dynamicProvider: { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1)
                case .light:
                    return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
                case .unspecified:
                    return .systemBackground
                @unknown default: return .systemBackground
                }
            })
        }
    }
    
    class var contentBackground: UIColor {
        get {
            .init(dynamicProvider: { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
                case .light:
                    return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
                case .unspecified:
                    return .systemBackground
                @unknown default: return .systemBackground
                }
            })
        }
    }
}

extension UITraitCollection {
    public static var isDarkMode: Bool {
        if current.userInterfaceStyle == .dark {
            return true
        }
        return false
    }
}
