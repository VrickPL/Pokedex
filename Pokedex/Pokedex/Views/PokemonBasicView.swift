//
//  PokemonBasicView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonBasicView: View {
    @State private var image: Image?
    @State var pokemon: PokemonBasic?
    @State var id: Int
    @State var width: CGFloat

    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(id: id, image: image)) {
                VStack {
                    PokemonImage(image: image, width: width)
                    
                    if let pokemon = pokemon {
                        Text(pokemon.name.capitalized)
                            .font(.custom("PressStart2P-Regular", size: 12))
                    }
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
    PokemonBasicView(pokemon: PokemonBasic(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"), id: 1, width: 150)
}
