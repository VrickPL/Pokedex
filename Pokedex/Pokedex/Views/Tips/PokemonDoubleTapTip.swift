//
//  PokemonDoubleTapTip.swift
//  Pokedex
//
//  Created by Jan Kazubski on 23/03/2024.
//

import Foundation
import TipKit

struct PokemonDoubleTapTip: Tip {
    var title = Text(LocalizedStringKey("pokemon_double_tap_tip_title"))
    var message: Text? = Text(LocalizedStringKey("pokemon_double_tap_tip_message"))
    var image: Image? = Image(systemName: "hand.tap.fill")
}
