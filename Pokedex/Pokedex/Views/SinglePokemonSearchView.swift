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
    
    @State private var couldntGetPokemonImage = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(pokemon: pokemon, image: image)) {
                HStack {
                    if let image = image {
                        PokemonImage(image: image, width: width)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: width)
                    } else {
                        LoadingView()
                    }
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
                self.couldntGetPokemonImage = false
            } catch is PokemonError {
                self.couldntGetPokemonImage = true
            } catch {
                // unexpected
                // TODO: show toast
                self.couldntGetPokemonImage = true
            }
        }
    }
}
