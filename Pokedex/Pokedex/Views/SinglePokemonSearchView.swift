//
//  SinglePokemonSearchView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SinglePokemonSearchView: View {
    @State private var image: Image?
    @State var pokemon: Pokemon
    @State var width: CGFloat

    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(pokemon: pokemon, image: image)) {
                HStack {
                    PokemonImage(image: image, width: width)
                    Text(pokemon.name.capitalized)
                        .font(.custom("PressStart2P-Regular", size: 16))
                        .foregroundStyle(Color("PokemonTextColor"))
                    
                    Spacer()
                }
            }
        }
        .task {
            do {
                image = try await PokemonViewModel(id: pokemon.id).getPokemonImage()
            } catch {
                // TODO: implement toast
            }
        }
    }
}
