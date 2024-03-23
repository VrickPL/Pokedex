//
//  PokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonView: View {
    @State private var image: Image?
    var pokemon: Pokemon?
    var id: Int
    var width: CGFloat
    
    @State var isInMyPokedex: Bool?
    @State private var couldntGetPokemonImage = false
    
    
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""

    var body: some View {
        VStack {
            NavigationLink(destination: DetailedPokemonView(id: id)) {
                VStack {
                    if let image = image {
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex!)
                    } else if couldntGetPokemonImage {
                        PokemonImage(image: nil, width: width, isInMyPokedex: isInMyPokedex!)
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
                image = try await PokemonImageViewModel(id: id).getSmallPokemonImage()
                self.couldntGetPokemonImage = false
            } catch is PokemonError {
                self.couldntGetPokemonImage = true
            } catch { }
        }
        .task {
            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
        }
        .onChange(of: favouritePokemons) {
            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
        }
    }
}

#Preview {
    PokemonView(pokemon: Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"), id: 1, width: 150)
}
