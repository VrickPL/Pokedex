//
//  SinglePokemonSearchView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SinglePokemonListView: View {
    @State private var image: Image?
    @State var pokemon: Pokemon
    @State var width: CGFloat
    @State var shouldShowTrash: Bool = false
    
    @State private var couldntGetPokemonImage = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(pokemon: pokemon, image: image)) {
                HStack {
                    let isInMyPokedex = FavouritePokemonsManager.shared.isPokemonInFavourites(pokemon.id)
                    if let image = image {
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex)
                    } else {
                        LoadingView()
                    }
                    Text(pokemon.name.capitalized)
                        .font(.custom("PressStart2P-Regular", size: 16))
                        .foregroundStyle(Color("PokemonTextColor"))
                    
                    Spacer()
                    
                    if shouldShowTrash {
                        Button {
                            FavouritePokemonsManager.shared.removePokemonId(pokemon.id)
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width / 2)
                        }
                        .padding()
                    }
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
