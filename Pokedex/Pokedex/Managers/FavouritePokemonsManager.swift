//
//  FavouritePokemonsManager.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation

class FavouritePokemonsManager {
    static let shared = FavouritePokemonsManager()
    
    private var pokemonsIdsData: Data {
        get {
            return UserDefaults.standard.data(forKey: "PokemonsIdsData") ?? Data()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PokemonsIdsData")
        }
    }
    
    var pokemonsIds: [Int] {
        get {
            if let decodedIntArray = try? JSONDecoder().decode([Int].self, from: pokemonsIdsData) {
                return decodedIntArray
            }
            return []
        }
        set {
            if let encodedIntArray = try? JSONEncoder().encode(newValue) {
                pokemonsIdsData = encodedIntArray
            }
        }
    }
    
    private init() {}
    
    func addPokemonId(_ id: Int) {
        var updatedIds = pokemonsIds
        updatedIds.append(id)
        pokemonsIds = updatedIds
    }
    
    func removePokemonId(_ id: Int) {
        var updatedIds = pokemonsIds
        if let index = updatedIds.firstIndex(of: id) {
            updatedIds.remove(at: index)
            pokemonsIds = updatedIds
        }
    }
    
    func isPokemonInFavourites(_ id: Int) -> Bool {
        return pokemonsIds.contains(id)
    }
}

