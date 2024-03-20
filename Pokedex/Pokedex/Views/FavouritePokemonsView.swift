//
//  FavouritePokemonsView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct FavouritePokemonsView: View {
    @State private var favouritePokemons: [Pokemon] = []
    @State private var couldntUpdatePokemons = true
    @State private var shouldReload = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                let width = UIScreen.main.bounds.width / 5
                let gridItems = [GridItem(.flexible(minimum: width + 10))]
                
                LazyVGrid(columns: gridItems, spacing: 20) {
                    if shouldReload || couldntUpdatePokemons {
                        if couldntUpdatePokemons && !shouldReload {
                            Text("couldntGetFavouritePokemons")
                                .foregroundStyle(.red)
                                .padding()
                        } else {
                            LoadingView()
                                .onAppear {
                                    shouldReload = false
                                }
                        }
                    } else if favouritePokemons.isEmpty {
                        Text("favouritePokemonsEmpty")
                            .foregroundStyle(.red)
                            .padding()
                    } else {
                        ForEach(favouritePokemons.indices, id: \.self) { index in
                            SinglePokemonListView(pokemon: favouritePokemons[index], width: width, shouldShowTrash: true)
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("APP_NAME")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    favouritePokemons = try await FavouritePokemonsViewModel().getPokemons()
                    self.couldntUpdatePokemons = false
                } catch {
                    //TODO: Toast
                    self.couldntUpdatePokemons = true
                }
            }
            .onChange(of: FavouritePokemonsManager.shared.pokemonsIds) {
                shouldReload = true
            }
        }
    }
}

#Preview {
    FavouritePokemonsView()
}
