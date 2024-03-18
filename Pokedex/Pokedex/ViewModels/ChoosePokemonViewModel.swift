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
    
    func updatePokemons() throws {
        let endpoint = next.isEmpty ? "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)" : next
        
        guard let url = URL(string: endpoint) else {
            throw PokemonError.invalidUrl
        }
        
        var errorToThrow: Error?
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if error == nil {
                if data != nil {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let myServiceResponse = try decoder.decode(PokemonsData.self, from: data!)
                        DispatchQueue.main.async {
                            self.results.append(contentsOf: myServiceResponse.results)
                            self.maxCount = myServiceResponse.count
                            self.next = myServiceResponse.next
                            self.myCount += myServiceResponse.results.count
                        }
                    } catch let exception {
                        errorToThrow = exception
                    }
                } else {
                    errorToThrow = PokemonError.invalidData
                }
            } else {
                errorToThrow = PokemonError.invalidResponse
            }
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        task.resume()
    }
    
    func findOnePokemon() throws {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(searchTerm.lowercased())/"
        
        guard let url = URL(string: endpoint) else {
            throw PokemonError.invalidUrl
        }
        
        var errorToThrow: Error?
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if error == nil {
                if data != nil {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let myServiceResponse = try decoder.decode(Pokemon.self, from: data!)
                        DispatchQueue.main.async {
                            self.pokemonFound = myServiceResponse
                        }
                    } catch let exception {
                        errorToThrow = exception
                    }
                } else {
                    errorToThrow = PokemonError.invalidData
                }
            } else {
                errorToThrow = PokemonError.invalidResponse
            }
        }
        
        if let error = errorToThrow {
            throw error
        }
        
        task.resume()
    }
}

