//
//  ChoosePokemonViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

class ChoosePokemonViewModel {
    var offset: Int = 0
    var limit: Int = 100
    var urlText: String?

    func getPokemons() async throws -> PokemonsData {
        let endpoint =  if let urlText = urlText {
            urlText
        } else {
            "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        }
        
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
            return try decoder.decode(PokemonsData.self, from: data)
        } catch {
            throw PokemonError.invalidData
        }
    }
}

