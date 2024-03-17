//
//  ChoosePokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct ChoosePokemonView: View {
    @ObservedObject private var viewModel = ChoosePokemonViewModel()
    
    private let pokemonWidth = UIScreen.main.bounds.width * 2 / 5
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.results == nil || viewModel.results!.isEmpty {
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
                        let gridItems = [GridItem(.adaptive(minimum: pokemonWidth + 10))]
                        
                        LazyVGrid(columns: gridItems, spacing: 20) {
                            if let pokemons = viewModel.results {
                                ForEach(pokemons.indices, id: \.self) { index in
                                    PokemonBasicView(pokemon: pokemons[index], id: index + 1, width: pokemonWidth)
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.4)
                                        }
                                }
                            }
                            if viewModel.maxCount > viewModel.myCount{
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
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ChoosePokemonView()
}
