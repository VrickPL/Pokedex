//
//  FavouritePokemonsManager.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation
import SwiftUI

class FavouritePokemonsManager {
    static let shared = FavouritePokemonsManager()
    init() {}

    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    
    func addPokemonId(_ id: Int) {
          if favouritePokemons.isEmpty {
              favouritePokemons.append("\(id)")
          } else {
              favouritePokemons.append(";\(id)")
          }
      }
    
    func removePokemonId(_ id: Int) {
        var ids = favouritePokemons.components(separatedBy: ";")
        
        if let index = ids.firstIndex(of: "\(id)") {
            ids.remove(at: index)
            favouritePokemons = ids.joined(separator: ";")
        }
    }

    
    func getPokemonsIds() -> [Int] {
        if favouritePokemons.isEmpty {
            return []
        }

        return favouritePokemons.components(separatedBy: ";").compactMap { Int($0) }
    }
    
    func checkIfIsSaved(_ id: Int) -> Bool {
        return getPokemonsIds().contains(id)
    }
}
