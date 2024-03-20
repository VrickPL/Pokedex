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
    @State private var isLoading = false
    
    @AppStorage(Keys.favouritePokemons) private var favouritePokemonsStorage: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                let width = UIScreen.main.bounds.width / 5
                let gridItems = [GridItem(.flexible(minimum: width + 10))]
                
                LazyVGrid(columns: gridItems, spacing: 20) {
                    if couldntUpdatePokemons {
                        Text("couldntGetFavouritePokemons")
                            .foregroundStyle(.red)
                            .padding()
                        
                    } else if favouritePokemons.isEmpty {
                        if isLoading {
                            LoadingView()
                        } else {
                            Text("favouritePokemonsEmpty")
                                .foregroundStyle(.red)
                                .padding()
                        }
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
                tryUpdateFavouritePokemons()
            }
            .onChange(of: favouritePokemonsStorage) {
                tryUpdateFavouritePokemons()
            }
        }
    }

    private func tryUpdateFavouritePokemons() {
        Task {
            do {
                self.favouritePokemons = []
                self.isLoading = true
                self.favouritePokemons = try await FavouritePokemonsViewModel().getPokemons()
                self.couldntUpdatePokemons = false
                self.isLoading = false
            } catch {
                //TODO: Toast
                self.couldntUpdatePokemons = true
                self.isLoading = false
            }
        }
    }
}

#Preview {
    FavouritePokemonsView()
}
