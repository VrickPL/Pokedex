//
//  ChoosePokemonViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

class ChoosePokemonViewModel: ObservableObject {
    @Published var results: [PokemonBasic] = []
    var maxCount: Int = 21
    var next: String = ""
    var myCount: Int = 0
    
    @Published var searchTerm: String = ""
    var filteredPokemons: [PokemonBasic] {
        return results.filter{ $0.name.localizedCaseInsensitiveContains(searchTerm) }
    }
    @Published var pokemonFound: Pokemon?

    private var offset: Int = 0
    private var limit: Int = 20

    func updatePokemons() async throws {
        let endpoint =  if next.isEmpty {
            "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        } else {
            next
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
            let myServiceResponse = try decoder.decode(PokemonsData.self, from: data)

            self.results.append(contentsOf: myServiceResponse.results)
            self.maxCount = myServiceResponse.count
            self.next = myServiceResponse.next
            self.myCount += myServiceResponse.results.count
        } catch {
            throw PokemonError.invalidData
        }
    }
    
    func findOneNewPokemon() async throws {
        self.pokemonFound = nil
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(searchTerm.lowercased())/"

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
            self.pokemonFound = try decoder.decode(Pokemon.self, from: data)
        } catch {
            throw PokemonError.invalidData
        }
    }
}
