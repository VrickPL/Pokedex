//
//  Language.swift
//  Pokedex
//
//  Created by Jan Kazubski on 18/03/2024.
//

import Foundation

enum Language: String, CaseIterable {
    case systemDefault = "auto"
    case english = "english"
    case polish = "polish"
    
    var locale: Locale {
        switch self {
        case .systemDefault:
            return Locale.current
        case .english:
            return Locale(identifier: "en")
        case .polish:
            return Locale(identifier: "pl")
        }
    }
}
