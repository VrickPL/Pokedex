//
//  PokemonSearchView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct PokemonSearchView: View {
    @State private var image: Image?
    @State var pokemon: PokemonBasic?
    @State var id: Int
    @State var width: CGFloat
    
    init(image: Image? = nil, pokemon: PokemonBasic? = nil, id: Int, width: CGFloat) {
        self.image = image
        self.pokemon = pokemon
        self.id = id
        self.width = width
    }

    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(id: id, image: image)) {
                HStack {
                    PokemonImage(image: image, width: width)
                    if let pokemon = pokemon {
                        Text(pokemon.name.capitalized)
                            .font(.custom("PressStart2P-Regular", size: 16))
                            .foregroundStyle(Color("PokemonTextColor"))
                    }
                    Spacer()
                }
            }
        }
        .task {
            do {
                image = try await PokemonViewModel(id: id).getPokemonImage()
            } catch {
                // TODO: implement toast
            }
        }
    }
}

#Preview {
    PokemonSearchView(pokemon: PokemonBasic(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"), id: 1, width: 80)
}
