//
//  ChoosePokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI
import TipKit

struct AllPokemonsView: View {
    @AppStorage(Keys.searchKey) private var search = true
    @ObservedObject private var viewModel = AllPokemonsViewModel()
    
    @State private var couldntUpdatePokemons = false
    @State private var couldntFindPokemon = false
    
    @State private var showToast = false
    @State private var toastOptions: ToastOptions = .unexpectedError

    init() {
        UINavigationBar.appearance().barTintColor = UIColor(Color("BackgroundColor"))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.allPokemons.isEmpty {
                        if couldntUpdatePokemons && !viewModel.isWaitingPokemons {
                            Text("couldntUpdatePokemons")
                                .foregroundStyle(.red)
                                .padding()
                        } else {
                            HStack {
                                Spacer()
                                LoadingPokemonsView(viewModel: viewModel, couldntUpdatePokemons: $couldntUpdatePokemons)
                                Spacer()
                            }
                        }
                    } else {
                        if viewModel.searchTerm.isEmpty {
                            let pokemonWidth = UIScreen.main.bounds.width * 2 / 5
                            let gridItems = [GridItem(.adaptive(minimum: pokemonWidth + 10))]
                            TipView(ClickPokemonTip())
                                .tipBackground(Color("PokemonBackgroundColor"))
                                .padding()

                            LazyVGrid(columns: gridItems, spacing: 20) {
                                let pokemons = viewModel.allPokemons
                                ForEach(pokemons.indices, id: \.self) { index in
                                    PokemonView(pokemon: pokemons[index], id: index + 1, width: pokemonWidth)
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.4)
                                        }
                                }

                                if !viewModel.next.isEmpty {
                                    if couldntUpdatePokemons && !viewModel.isWaitingPokemons {
                                        Text("couldntUpdatePokemons")
                                            .foregroundStyle(.red)
                                            .padding()
                                    } else {
                                        LoadingPokemonsView(viewModel: viewModel, couldntUpdatePokemons: $couldntUpdatePokemons)
                                        LoadingView()
                                    }
                                }
                            }
                        } else {
                            let pokemonWidth = UIScreen.main.bounds.width * 1 / 5
                            let allPokemons = viewModel.allPokemons
                            let filteredPokemons = viewModel.filteredPokemons
                            
                            let gridItems = [GridItem(.flexible(minimum: pokemonWidth + 10))]
                            
                            LazyVGrid(columns: gridItems, spacing: 20) {
                                if search {
                                    if let pokemon = viewModel.pokemonFound {
                                        SinglePokemonListView(pokemon: pokemon, width: pokemonWidth, shouldShowTrash: false)
                                    } else {
                                        if couldntFindPokemon || (!viewModel.isWaitingSinglePokemon && viewModel.pokemonFound == nil) {
                                            Text("couldntFindPokemon")
                                                .foregroundStyle(.red)
                                                .padding()
                                        } else {
                                            LoadingView()
                                        }
                                    }
                                } else {
                                    if filteredPokemons.isEmpty {
                                        Text("couldntFindPokemons")
                                            .foregroundStyle(.red)
                                    } else {
                                        ForEach(allPokemons.indices, id: \.self) { index in
                                            if filteredPokemons.contains(allPokemons[index]) {
                                                SinglePokemonListView(pokemonId: index + 1, pokemonName: allPokemons[index].name, width: pokemonWidth)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchTerm)
            .background(Color("BackgroundColor"))
            .navigationTitle("APP_NAME")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundColor(Color("PokemonTextColor"))
                    }
            )
            .onChange(of: viewModel.searchTerm) {
                if search {
                    do {
                        try viewModel.findOnePokemon()
                        self.couldntFindPokemon = false
                    } catch is PokemonError {
                        self.couldntFindPokemon = true
                    } catch {
                        self.toastOptions = .unexpectedError
                        self.showToast = true
                        self.couldntFindPokemon = true
                    }
                }
            }
            .simpleToast(isPresented: $showToast, options: getToastConfig(), onDismiss: {}) {
                ToastPopUpView(text: toastOptions.rawValue, color: toastOptions.getColor())
            }
        }
    }
    
    private struct LoadingPokemonsView: View {
        @ObservedObject var viewModel: AllPokemonsViewModel
        @Binding var couldntUpdatePokemons: Bool
        
        @State private var showToast = false
        @State private var toastOptions: ToastOptions = .unexpectedError
        
        var body: some View {
            LoadingView()
                .onAppear {
                    do {
                        try viewModel.updatePokemons()
                        self.couldntUpdatePokemons = false
                    } catch is PokemonError {
                        self.couldntUpdatePokemons = true
                    } catch {
                        self.toastOptions = .unexpectedError
                        self.showToast = true
                        self.couldntUpdatePokemons = true
                    }
                }
                .simpleToast(isPresented: $showToast, options: getToastConfig(), onDismiss: {}) {
                    ToastPopUpView(text: toastOptions.rawValue, color: toastOptions.getColor())
                }
        }
    }
}

#Preview {
    AllPokemonsView()
}
