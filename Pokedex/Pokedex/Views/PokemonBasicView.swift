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
    
    @State private var couldntGetPokemonImage = false
    

    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(id: id, image: image)) {
                VStack {
                    if let image = image {
                        PokemonImage(image: image, width: width)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: width)
                    } else {
                        LoadingView()
                    }
                    
                    if let pokemon = pokemon {
                        Text(pokemon.name.capitalized)
                            .font(.custom("PressStart2P-Regular", size: 12))
                            .foregroundStyle(Color("PokemonTextColor"))
                    }
                }
            }
        }
        .task {
            do {
                image = try await PokemonViewModel(id: id).getPokemonImage()
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

#Preview {
    PokemonBasicView(pokemon: PokemonBasic(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"), id: 1, width: 150)
}
