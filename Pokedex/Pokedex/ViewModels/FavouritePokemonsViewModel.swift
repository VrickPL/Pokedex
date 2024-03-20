//
//  FavouritePokemonsViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation

class FavouritePokemonsViewModel {
    var ids: [Int] = FavouritePokemonsManager.shared.pokemonsIds
    
    func getPokemons() async throws -> [Pokemon] {
        var pokemons: [Pokemon] = []
        
        for id in ids{
            pokemons.append(try await PokemonViewModel(id: id).getPokemon())
        }
        
        return pokemons
    }
}
