//
//  PokemonsData.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

struct AllPokemons: Codable {
    let results: [Pokemon]
    let next: String
}
