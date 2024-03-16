//
//  Errors.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

enum PokemonError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}
