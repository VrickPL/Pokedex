//
//  ToastOptions.swift
//  Pokedex
//
//  Created by Jan Kazubski on 21/03/2024.
//

import Foundation
import SwiftUI

enum ToastOptions: String {
    case successAddPokemon = "success_add_pokemon"
    case successDeletePokemon = "success_delete_pokemon"
    case unexpectedError = "unexpected_error"
    case couldNotUpdate = "could_not_update"
    
    func getColor() -> Color {
        return self.rawValue.contains("success") ? Color.green : Color.red
    }
}
