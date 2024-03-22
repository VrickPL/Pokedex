//
//  PokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI
import SimpleToast

struct DetailedPokemonView: View {
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    @State private var image: Image?
    @State private var pokemon: DetailedPokemon?
    @State private var isInMyPokedex: Bool = false
    @State private var couldntGetPokemon = false
    @State private var couldntGetPokemonImage = false
    private var id: Int
    private let pokemonWidth = UIScreen.main.bounds.width / 2
    
    @State private var showToast = false
    @State private var showToastAdd = false
    @State private var showToastDelete = false
    @State private var toastOptions: ToastOptions = .successAddPokemon
    
    init(id: Int) {
        self.id = id
    }
    
    init(pokemon: DetailedPokemon) {
        self.id = pokemon.id
        self.pokemon = pokemon
    }
    
    
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
                        image
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else if couldntGetPokemonImage {
                        PokemonImage(image: nil, width: pokemonWidth, isInMyPokedex: isInMyPokedex)
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
                            self.toastOptions = .successDeletePokemon
                            self.showToastDelete = true
                        } label: {
                            Text("remove_from_pokeball")
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button {
                            self.toastOptions = .successAddPokemon
                            self.showToastAdd = true
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
                    if pokemon == nil {
                        pokemon = try await DetailedPokemonViewModel(id: id).getPokemon()
                    }
                    self.couldntGetPokemon = false
                    self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
                } catch is PokemonError {
                    self.couldntGetPokemon = true
                } catch {
                    self.toastOptions = .unexpectedError
                    self.showToast = true
                    self.couldntGetPokemon = true
                }
            }
            .task {
                if image == nil {
                    do {
                        self.image = try await PokemonImageViewModel(id: id).getBigPokemonImage()
                        self.couldntGetPokemonImage = false
                    } catch is PokemonError {
                        self.couldntGetPokemonImage = true
                    } catch {
                        self.toastOptions = .unexpectedError
                        self.showToast = true
                        self.couldntGetPokemonImage = true
                    }
                }
            }
            .onChange(of: favouritePokemons) {
                self.isInMyPokedex = FavouritePokemonsManager.shared.checkIfIsSaved(id)
            }
            .simpleToast(isPresented: $showToast, options: getToastConfig(), onDismiss: {}) {
                ToastPopUpView(text: toastOptions.rawValue, color: toastOptions.getColor())
            }
            .simpleToast(isPresented: $showToastAdd, options: getToastConfig(), onDismiss: {
                FavouritePokemonsManager.shared.addPokemonId(id)
            }) {
                ToastPopUpView(text: toastOptions.rawValue, color: toastOptions.getColor())
            }
            .simpleToast(isPresented: $showToastDelete, options: getToastConfig(), onDismiss: {
                FavouritePokemonsManager.shared.removePokemonId(id)
            }) {
                ToastPopUpView(text: toastOptions.rawValue, color: toastOptions.getColor())
            }
        }
    }
}

#Preview {
    DetailedPokemonView(id: 91)
}
