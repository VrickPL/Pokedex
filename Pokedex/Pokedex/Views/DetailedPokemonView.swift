//
//  PokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct DetailedPokemonView: View {
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    @State private var image: Image?
    @State private var pokemon: DetailedPokemon?
    @State private var isInMyPokedex: Bool = false
    @State private var couldntGetPokemon = false
    @State private var couldntGetPokemonImage = false
    private var id: Int
    private let pokemonWidth = UIScreen.main.bounds.width / 2
    
    init(id: Int, image: Image? = nil) {
        self.id = id
        self.image = image
    }
    
    init(pokemon: DetailedPokemon, image: Image?) {
        self.id = pokemon.id
        self.image = image
        self.pokemon = pokemon
    }


    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onAppear {
                    self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
                }
            
            VStack {
                if couldntGetPokemon {
                    Text("couldntGetPokemon")
                        .foregroundStyle(Color.red)
                } else if pokemon == nil {
                    LoadingView()
                } else {
                    if let image = image {
                        PokemonImage(image: image, width: pokemonWidth, isInMyPokedex: isInMyPokedex)
                    } else if couldntGetPokemonImage {
                        let image = Image("PokemonWithoutImage")
                        PokemonImage(image: image, width: pokemonWidth, isInMyPokedex: isInMyPokedex)
                    } else {
                        LoadingView()
                    }
                    
                    Text(pokemon!.name.capitalized)
                        .font(.custom("PressStart2P-Regular", size: 18))
                        .padding(.bottom)
                    
                    HStack {
                        Text(LocalizedStringKey("weight")).bold()
                        Text("\(pokemon!.weight / 10)kg")
                        Spacer()
                    }
                    HStack {
                        Text(LocalizedStringKey("height")).bold()
                        Text("\(pokemon!.height * 10)cm")
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.bottom)

                    if isInMyPokedex {
                        Button {
                            FavouritePokemonsManager.shared.removePokemonId(id)
                        } label: {
                            Text("remove_from_pokeball")
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button {
                            FavouritePokemonsManager.shared.addPokemonId(id)
                        } label: {
                            Text("catch_in_pokeball")
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            .task {
                do {
                    pokemon = try await DetailedPokemonViewModel(id: id).getPokemon()
                    self.couldntGetPokemon = false
                } catch is PokemonError {
                    self.couldntGetPokemon = true
                } catch {
                    // unexpected
                    // TODO: show toast
                    self.couldntGetPokemon = true
                }
            }
            .task {
                if image == nil {
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
            }
            .onChange(of: favouritePokemons) {
                self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
            }
        }
    }
}

#Preview {
    DetailedPokemonView(id: 400)
}