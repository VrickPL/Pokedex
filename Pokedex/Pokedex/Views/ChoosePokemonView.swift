//
//  ChoosePokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct ChoosePokemonView: View {
    @ObservedObject private var viewModel = ChoosePokemonViewModel()
    @State var searchType: SearchType
    
    init(searchType: SearchType) {
        UINavigationBar.appearance().barTintColor = UIColor(Color("BackgroundColor"))
        self.searchType = searchType
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.results.isEmpty {
                        LoadingView()
                            .onAppear {
                                do {
                                    try viewModel.updatePokemons()
                                } catch is PokemonError {
                                    // TODO: implement toast
                                } catch {
                                    // unexpected
                                }
                            }
                    } else {
                        if viewModel.searchTerm.isEmpty {
                            let pokemonWidth = UIScreen.main.bounds.width * 2 / 5
                            let gridItems = [GridItem(.adaptive(minimum: pokemonWidth + 10))]
                            
                            LazyVGrid(columns: gridItems, spacing: 20) {
                                let pokemons = viewModel.results
                                ForEach(pokemons.indices, id: \.self) { index in
                                    PokemonBasicView(pokemon: pokemons[index], id: index + 1, width: pokemonWidth)
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.4)
                                        }
                                }
                                
                                if !viewModel.next.isEmpty {
                                    LoadingView()
                                        .onAppear {
                                            do {
                                                try viewModel.updatePokemons()
                                            } catch is PokemonError {
                                                // TODO: implement toast
                                            } catch {
                                                // unexpected
                                            }
                                        }
                                    LoadingView()
                                }
                            }
                        } else {
                            let pokemonWidth = UIScreen.main.bounds.width * 1 / 5
                            let allPokemons = viewModel.results
                            let filteredPokemons = viewModel.filteredPokemons
                            
                            let gridItems = [GridItem(.flexible(minimum: pokemonWidth + 10))]
                            
                            LazyVGrid(columns: gridItems, spacing: 20) {
                                if searchType == SearchType.fetchedPokemons {
                                    ForEach(allPokemons.indices, id: \.self) { index in
                                        if filteredPokemons.contains(allPokemons[index]) {
                                            PokemonSearchView(pokemon: allPokemons[index], id: index + 1, width: pokemonWidth)
                                        }
                                    }
                                } else {
                                    if let pokemon = viewModel.pokemonFound {
                                        SinglePokemonSearchView(pokemon: pokemon, width: pokemonWidth)
                                    } else {
                                        LoadingView()
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
                trailing: NavigationLink(destination: SettingsView(search: true)) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundColor(Color("PokemonTextColor"))
                    }
            )
            .onChange(of: viewModel.searchTerm) {
                if searchType == SearchType.singlePokemon {
                    do {
                        try viewModel.findOnePokemon()
                    } catch is PokemonError {
                        // TODO: implement toast
                    } catch {
                        // unexpected
                    }
                }
            }
        }
    }
}
    


#Preview {
    ChoosePokemonView(searchType: SearchType.singlePokemon)
}
