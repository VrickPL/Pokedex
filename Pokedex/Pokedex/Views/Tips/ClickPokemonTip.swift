//
//  ClickPokemonTip.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation
import TipKit

struct ClickPokemonTip: Tip {
    var title = Text(LocalizedStringKey("click_pokemon_tip_title"))
    var message: Text? = Text(LocalizedStringKey("click_pokemon_tip_message"))
    var image: Image? = Image(systemName: "hand.tap.fill")
}
