//
//  SinglePokemonListView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SinglePokemonListView: View {
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    @State private var isInMyPokedex: Bool?
    @State private var couldntGetPokemonImage = false
    @State private var image: Image?
    private var pokemonId: Int
    private var pokemonName: String
    private var width: CGFloat
    private var shouldShowTrash: Bool


    init(pokemon: DetailedPokemon, width: CGFloat, shouldShowTrash: Bool) {
        self.pokemonId = pokemon.id
        self.pokemonName = pokemon.name
        self.width = width
        self.shouldShowTrash = shouldShowTrash
        
        if isInMyPokedex == nil {
            isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemonId)
        }
    }
    
    init(pokemonId: Int, pokemonName: String, width: CGFloat) {
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
        self.width = width
        self.shouldShowTrash = false
        
        if isInMyPokedex == nil {
            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemonId)
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: DetailedPokemonView(id: pokemonId, image: image)) {
                HStack {
                    if let image = image {
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex!)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex!)
                    } else {
                        LoadingView()
                    }
                    Text(pokemonName.capitalized)
                        .font(.custom("PressStart2P-Regular", size: 16))
                        .foregroundStyle(Color("PokemonTextColor"))
                        .onAppear {
                            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemonId)
                        }
                    
                    Spacer()
                    
                    if shouldShowTrash {
                        Button {
                            FavouritePokemonsManager.shared.removePokemonId(pokemonId)
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
            await fetchImage()
        }
        .onChange(of: favouritePokemons) {
            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemonId)
            Task {
                await fetchImage()
            }
        }
    }
    
    private func fetchImage() async {
        do {
            self.image = try await DetailedPokemonViewModel(id: pokemonId).getPokemonImage()
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
