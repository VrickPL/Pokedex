//
//  Pokemon.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

struct DetailedPokemon: Codable {
    let name: String
    let id, height, weight: Int
}