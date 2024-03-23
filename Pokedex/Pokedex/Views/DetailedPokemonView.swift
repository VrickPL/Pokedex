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
    
    @State private var isShowingDescription: Bool = false
    
    init(id: Int) {
        self.id = id
    }
    
    init(pokemon: DetailedPokemon) {
        self.id = pokemon.id
        self.pokemon = pokemon
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                            PokemonImage(image: nil, width: pokemonWidth, isInMyPokedex: false)
                        } else {
                            LoadingView()
                        }
                        
                        HStack {
                            if isInMyPokedex {
                                Image(.pokeball)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width / 15)
                                    .padding(.bottom)
                            }
                            Text(pokemon!.name.capitalized)
                                .font(.custom("PressStart2P-Regular", size: 18))
                                .padding(.bottom)
                            if isInMyPokedex {
                                Image(.pokeball)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width / 15)
                                    .padding(.bottom)
                            }
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible(minimum: 100)), GridItem(.flexible(minimum: 100))]) {
                            ForEach(pokemon!.types.indices, id: \.self) { index in
                                if shouldPokemonTypeBeVisible(index) {
                                    getTypeView(for: index)
                                }
                            }
                        }
                        HStack {
                            if isPokemonTypesCountOdd() {
                                Spacer()
                                getTypeView(for: pokemon!.types.count - 1)
                                Spacer()
                            }
                        }
                        
                        VStack {
                            Button {
                                isShowingDescription.toggle()
                            } label: {
                                HStack {
                                    Text("description")
                                        .bold()
                                    Spacer()
                                    Text(isShowingDescription ? "▲" : "▼")
                                }
                                .font(.title)
                                .foregroundStyle(Color("ReversedColor"))
                                .padding()
                            }

                            if isShowingDescription {
                                Color("ReversedColor").frame(height: 1)
                                    .padding(.leading)
                                    .padding(.trailing)
                                
                                ForEach(pokemon!.stats.indices, id: \.self) { index in
                                    getSkillView(for: index)
                                }
                                HStack {
                                    Text(LocalizedStringKey("weight")).bold()
                                    Text("\(pokemon!.weight / 10)kg")
                                    Spacer()
                                }
                                .padding(.leading)
                                .padding(.top)
                                HStack {
                                    Text(LocalizedStringKey("height")).bold()
                                    Text("\(pokemon!.height * 10)cm")
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("ReversedColor"), lineWidth: 1)
                        )
                        .padding()
                        
                        
                        if isInMyPokedex {
                            Button {
                                self.toastOptions = .successDeletePokemon
                                self.showToastDelete = true
                            } label: {
                                Text("remove_from_pokeball")
                                    .foregroundStyle(Color("ReversedColor"))
                                    .padding()
                                    .background(Color("BackgroundColor"))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("ReversedColor"), lineWidth: 1)
                                    )
                            }
                        } else {
                            Button {
                                self.toastOptions = .successAddPokemon
                                self.showToastAdd = true
                            } label: {
                                Text("catch_in_pokeball")
                                    .foregroundStyle(Color("ReversedColor"))
                                    .padding()
                                    .background(Color("BackgroundColor"))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("ReversedColor"), lineWidth: 1)
                                    )
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
            .background(getBackgroundColor())
        }
    }
    
    private func isPokemonTypesCountOdd() -> Bool {
        return pokemon!.types.count % 2 == 1
    }
    
    private func shouldPokemonTypeBeVisible(_ index: Int) -> Bool {
            if !isPokemonTypesCountOdd() {
                return true
            } else {
                if pokemon!.types.count - 1 != index {
                    return true
                } else {
                    return false
                }
            }
        }
    
    private func getBackgroundColor() -> Color {
        if couldntGetPokemon || pokemon == nil {
            return Color("BackgroundColor")
        } else if let color = pokemon!.getColorForType().map({ Color(hex: $0) }) {
            return color.opacity(0.6)
        } else {
            return Color("BackgroundColor")
        }
    }
    
    
    private func getTypeView(for index: Int) -> some View {
        ZStack {
            Color(hex: pokemon!.getColorForType(index) ?? "#A8A77A")
            
            Text(LocalizedStringKey(pokemon!.types[index].type.name))
                .bold()
                .padding()
        }
        .background(Color(hex: pokemon!.getColorForType(index) ?? "#A8A77A"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("ReversedColor"), lineWidth: 1)
        )
        .padding()
    }
    
    
    private func getSkillView(for index: Int) -> some View {
        HStack {
            Text(LocalizedStringKey(pokemon!.stats[index].stat.name)).bold()
            Text("\(pokemon!.stats[index].baseStat)")
            Spacer()
        }
        .padding(.leading)
        .padding(.top)
    }
}

#Preview {
    DetailedPokemonView(id: 1)
}
