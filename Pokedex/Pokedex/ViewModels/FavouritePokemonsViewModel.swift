//
//  FavouritePokemonsViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation
import SwiftUI

class FavouritePokemonsViewModel {
    func getPokemons() async throws -> [DetailedPokemon] {
        var pokemons: [DetailedPokemon] = []
        
        for id in FavouritePokemonsManager.shared.getPokemonsIds() {
            pokemons.append(try await DetailedPokemonViewModel(id: id).getPokemon())
        }
        
        return pokemons
    }
}
