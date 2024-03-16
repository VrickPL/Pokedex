//
//  PokemonsBasicViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

class PokemonViewModel {
    var id: Int = 1

    func getPokemon() async throws -> Pokemon {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: endpoint) else {
            throw PokemonError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PokemonError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Pokemon.self, from: data)
        } catch {
            throw PokemonError.invalidData
        }
    }
}
