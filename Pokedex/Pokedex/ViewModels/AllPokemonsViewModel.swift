//
//  AllPokemonsViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import Foundation

class AllPokemonsViewModel: ObservableObject {
    @Published var isWaitingPokemons: Bool = false
    @Published var isWaitingSinglePokemon: Bool = false
    @Published var allPokemons: [Pokemon] = []
    var next: String = ""
    
    @Published var searchTerm: String = ""
    var filteredPokemons: [Pokemon] {
        return allPokemons.filter{ $0.name.localizedCaseInsensitiveContains(searchTerm) }
    }
    @Published var pokemonFound: DetailedPokemon?
    
    private var offset: Int = 0
    private var limit: Int = 20
    
    func updatePokemons() throws {
        self.isWaitingPokemons = true
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
                        let myServiceResponse = try decoder.decode(AllPokemons.self, from: data!)
                        DispatchQueue.main.async {
                            if myServiceResponse.results.isEmpty {
                                errorToThrow = PokemonError.couldntFindPokemon
                            }
                            
                            self.allPokemons.append(contentsOf: myServiceResponse.results)
                            self.next = myServiceResponse.next
                            self.isWaitingPokemons = false
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
        self.isWaitingSinglePokemon = true
        self.pokemonFound = nil
        
        if searchTerm.isEmpty { return }
        
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
                        let myServiceResponse = try decoder.decode(DetailedPokemon.self, from: data!)
                        DispatchQueue.main.async {
                            self.pokemonFound = myServiceResponse
                            self.isWaitingSinglePokemon = false
                        }
                    } catch let exception {
                        DispatchQueue.main.async {
                            self.isWaitingSinglePokemon = false
                        }

                        errorToThrow = exception
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isWaitingSinglePokemon = false
                    }

                    errorToThrow = PokemonError.invalidData
                }
            } else {
                DispatchQueue.main.async {
                    self.isWaitingSinglePokemon = false
                }

                errorToThrow = PokemonError.invalidResponse
            }
        }
        
        if let error = errorToThrow {
            throw error
        }

        task.resume()
    }

    func refreshData(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let newViewModel = AllPokemonsViewModel()
            try newViewModel.updatePokemons()
            self.allPokemons = newViewModel.allPokemons
            self.next = newViewModel.next
            
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

