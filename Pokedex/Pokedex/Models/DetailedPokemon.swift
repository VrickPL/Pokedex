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
    let types: [PokemonType]

    struct PokemonType: Codable {
        let slot: Int
        let type: TypeDetails

        struct TypeDetails: Codable {
            let name: String
        }
    }
    
    func getColorForType() -> String? {
        switch self.types[0].type.name.lowercased() {
            case "normal":
                return "#A8A77A" // Tan
            case "fire":
                return "#EE8130" // Red
            case "water":
                return "#6390F0" // Blue
            case "electric":
                return "#F7D02C" // Yellow
            case "grass":
                return "#7AC74C" // Green
            case "ice":
                return "#96D9D6" // Cyan
            case "fighting":
                return "#C22E28" // Dark Red
            case "poison":
                return "#A33EA1" // Purple
            case "ground":
                return "#E2BF65" // Brown
            case "flying":
                return "#A98FF3" // Lavender
            case "psychic":
                return "#F95587" // Pink
            case "bug":
                return "#A6B91A" // Lime
            case "rock":
                return "#B6A136" // Gold
            case "ghost":
                return "#735797" // Indigo
            case "dragon":
                return "#6F35FC" // Violet
            case "dark":
                return "#705746" // Dark Brown
            case "steel":
                return "#B7B7CE" // Silver
            case "fairy":
                return "#D685AD" // Light Pink
            default:
                return nil
        }
    }
}
