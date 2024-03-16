//
//  ChoosePokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct ChoosePokemonView: View {
    @State private var pokemonsData: PokemonsData?
    
    private let pokemonWidth = UIScreen.main.bounds.width * 2 / 5
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if pokemonsData == nil {
                        LoadingView()
                    } else {
                        let gridItems = [GridItem(.adaptive(minimum: pokemonWidth + 10))]

                        LazyVGrid(columns: gridItems, spacing: 20) {
                            if let pokemons = pokemonsData?.results {
                                ForEach(pokemons.indices, id: \.self) { index in
                                    PokemonBasicView(pokemon: pokemons[index], id: index + 1, width: pokemonWidth)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            do {
                pokemonsData = try await ChoosePokemonViewModel().getPokemons()
            } catch {
                // TODO: implement toast
            }
        }
    }
}

#Preview {
    ChoosePokemonView()
}
