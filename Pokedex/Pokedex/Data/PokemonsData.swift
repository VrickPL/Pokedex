//
//  PokemonsData.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

struct PokemonsData: Codable {
    let results: [PokemonBasic]
    let next: String
}
