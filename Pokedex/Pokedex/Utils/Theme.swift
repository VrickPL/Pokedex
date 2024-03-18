//
//  Theme.swift
//  Pokedex
//
//  Created by Jan Kazubski on 18/03/2024.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case systemDefault = "auto"
    case light = "light"
    case dark = "dark"
    
    var colorScheme: ColorScheme? {
        return switch self {
        case .systemDefault:
            nil
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}
