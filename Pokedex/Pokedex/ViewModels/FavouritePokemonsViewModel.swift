//
//  FavouritePokemonsViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation
import SwiftUI

class FavouritePokemonsViewModel {
    func getPokemons() async throws -> [Pokemon] {
        var pokemons: [Pokemon] = []
        
        for id in FavouritePokemonsManager.shared.getPokemonsIds() {
            pokemons.append(try await PokemonViewModel(id: id).getPokemon())
        }
        
        return pokemons
    }
}
