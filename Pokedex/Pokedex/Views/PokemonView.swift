//
//  PokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonView: View {
    @State var id: Int
    @State var image: Image?
    @State private var pokemon: Pokemon?
    @State var isInMyPokedex: Bool
    
    @State private var couldntGetPokemon = false
    @State private var couldntGetPokemonImage = false
    
    init(id: Int, image: Image? = nil) {
        self.id = id
        self.image = image
        self.isInMyPokedex = FavouritePokemonsManager.shared.isPokemonInFavourites(id)
    }
    
    init(pokemon: Pokemon, image: Image?) {
        self.id = pokemon.id
        self.image = image
        self.pokemon = pokemon
        self.isInMyPokedex = FavouritePokemonsManager.shared.isPokemonInFavourites(pokemon.id)
    }
    
    private let pokemonWidth = UIScreen.main.bounds.width / 2

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
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
                            if let pokemon = pokemon {
                                FavouritePokemonsManager.shared.addPokemonId(pokemon.id)
                                isInMyPokedex.toggle()
                            } else {
                                //TODO show toast
                            }
                        } label: {
                            Text("remove_from_pokeball")
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button {
                            if let pokemon = pokemon {
                                FavouritePokemonsManager.shared.removePokemonId(pokemon.id)
                                isInMyPokedex.toggle()
                            } else {
                                //TODO show toast
                            }
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
                    pokemon = try await PokemonViewModel(id: id).getPokemon()
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
    }
}

#Preview {
    PokemonView(id: 400)
}
