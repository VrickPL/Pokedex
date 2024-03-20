//
//  SinglePokemonSearchView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SinglePokemonListView: View {
    var pokemon: Pokemon
    @State var width: CGFloat
    @State var shouldShowTrash: Bool

    @State private var isInMyPokedex: Bool?
    @State private var couldntGetPokemonImage = false
    @State private var image: Image?
    
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    
    init(pokemon: Pokemon, width: CGFloat, shouldShowTrash: Bool) {
        self.pokemon = pokemon
        self.width = width
        self.shouldShowTrash = shouldShowTrash
        
        if isInMyPokedex == nil {
            isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemon.id)
        }
    }
    
    init(pokemon: Pokemon, width: CGFloat) {
        self.pokemon = pokemon
        self.width = width
        self.shouldShowTrash = false
        
        if isInMyPokedex == nil {
            isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemon.id)
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: PokemonView(pokemon: pokemon, image: image)) {
                HStack {
                    if let image = image {
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex!)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: width, isInMyPokedex: isInMyPokedex!)
                    } else {
                        LoadingView()
                    }
                    Text(pokemon.name.capitalized)
                        .font(.custom("PressStart2P-Regular", size: 16))
                        .foregroundStyle(Color("PokemonTextColor"))
                        .onAppear {
                            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemon.id)
                        }
                    
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
            await fetchImage()
        }
        .onChange(of: favouritePokemons) {
            self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(pokemon.id)
            Task {
                await fetchImage()
            }
        }
    }
    
    private func fetchImage() async {
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
