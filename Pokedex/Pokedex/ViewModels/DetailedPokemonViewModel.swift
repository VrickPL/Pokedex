//
//  PokemonsBasicViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation
import SwiftUI

class DetailedPokemonViewModel {
    private var id: Int
    
    init(id: Int) {
        self.id = id
    }

    func getPokemon() async throws -> DetailedPokemon {
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
            return try decoder.decode(DetailedPokemon.self, from: data)
        } catch {
            throw PokemonError.invalidData
        }
    }
    
    func getPokemonImage() async throws -> Image {
        let endpoint = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        guard let url = URL(string: endpoint) else {
            throw PokemonError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PokemonError.invalidResponse
        }
        
        guard let uiImage = UIImage(data: data) else {
            throw PokemonError.invalidData
        }
            
        return Image(uiImage: uiImage)
    }
}
