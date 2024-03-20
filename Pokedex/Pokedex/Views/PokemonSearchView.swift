//
//  PokemonSearchView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct PokemonSearchView: View {
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    @State private var image: Image?
    @State private var isInMyPokedex = false
    @State private var couldntGetPokemonImage = false
    private var pokemon: Pokemon?
    private var id: Int
    private var width: CGFloat
    
    
    init(image: Image? = nil, pokemon: Pokemon? = nil, id: Int, width: CGFloat) {
        self.image = image
        self.pokemon = pokemon
        self.id = id
        self.width = width
    }

    var body: some View {
        VStack {
            NavigationLink(destination: DetailedPokemonView(id: id, image: image)) {
                HStack {
                    if let image = image {
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex)
                    } else {
                        LoadingView()
                    }
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
                self.image = try await DetailedPokemonViewModel(id: id).getPokemonImage()
                self.couldntGetPokemonImage = false
            } catch is PokemonError {
                self.couldntGetPokemonImage = true
            } catch {
                // unexpected
                // TODO: show toast
                self.couldntGetPokemonImage = true
            }
        }
        .onChange(of: favouritePokemons) {
            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
        }
    }
}

#Preview {
    PokemonSearchView(pokemon: Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"), id: 1, width: 80)
}
