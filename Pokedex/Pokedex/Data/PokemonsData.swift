//
//  PokemonsData.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

struct PokemonsData: Codable {
    let count: Int
    let results: [PokemonBasic]
    let next: String
}
