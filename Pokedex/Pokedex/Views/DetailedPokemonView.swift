//
//  DetailedPokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI
import SimpleToast

struct DetailedPokemonView: View {
    @AppStorage(Keys.favouritePokemons) private var favouritePokemons: String = ""
    @AppStorage(Keys.wasTipPokemonDoubleTapShownBefore) private var wasTipShownBefore: Bool = false
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
    
    @State private var isImageDoubleClicked = false
    
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
                        HStack {
                            Spacer()
                            LoadingView()
                            Spacer()
                        }
                    } else {
                        getPokemonImage()
                        
                        getPokemonName()
                        
                        getPokemonTypes()
                        
                        getPokemonDescription()
                        
                        getFavouriteButton()
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
            }
            .background(getBackgroundColor())
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
    
    private func getBackgroundColor() -> Color {
        if couldntGetPokemon || pokemon == nil {
            return Color("BackgroundColor")
        } else if let color = pokemon!.getColorForType().map({ Color(hex: $0) }) {
            return color.opacity(0.6)
        } else {
            return Color("BackgroundColor")
        }
    }
    
    private func getPokemonImage() -> some View {
        VStack {
            let view = VStack {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .onTapGesture(count: 2, perform: handleImageDoubleTap)
                    
                } else if couldntGetPokemonImage {
                    PokemonImage(image: nil, width: pokemonWidth, isInMyPokedex: false)
                        .onTapGesture(count: 2, perform: handleImageDoubleTap)
                } else {
                    LoadingView()
                }
            }
            
            if !wasTipShownBefore {
                view
                    .popoverTip(PokemonDoubleTapTip(), arrowEdge: .top)
                    .onDisappear{ wasTipShownBefore = true }
            } else {
                view
            }
        }
    }
    
    private func getPokemonName() -> some View {
        HStack {
            if isImageDoubleClicked {
                PokeballAnimation()
                    .padding(.bottom)
            } else {
                if isInMyPokedex {
                    Image(.pokeball)
                        .resizable()
                        .scaledToFit()
                        .frame(width: PokeballAnimation.width)
                        .padding(.bottom)
                }
            }
            
            Text(pokemon!.name.capitalized)
                .font(.custom("PressStart2P-Regular", size: 18))
                .padding(.bottom)
            
            if isImageDoubleClicked {
                PokeballAnimation()
                    .padding(.bottom)
            } else {
                if isInMyPokedex {
                    Image(.pokeball)
                        .resizable()
                        .scaledToFit()
                        .frame(width: PokeballAnimation.width)
                        .padding(.bottom)
                }
            }
        }
    }
    
    private func getPokemonTypes() -> some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible(minimum: 100)), GridItem(.flexible(minimum: 100))]) {
                ForEach(pokemon!.types.indices, id: \.self) { index in
                    if shouldPokemonTypeBeVisible(index) {
                        getTypeView(for: index)
                    }
                }
            }
            HStack {
                if arePokemonTypesCountOdd() {
                    Spacer()
                    getTypeView(for: pokemon!.types.count - 1)
                    Spacer()
                }
            }
        }
    }
    
    private func getPokemonDescription() -> some View {
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
    }
    
    private func getFavouriteButton() -> some View {
        if isInMyPokedex {
            Button {
                self.toastOptions = .successDeletePokemon
                self.showToastDelete = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } label: {
                getFavouriteButtonView(for: "remove_from_pokeball")
            }
        } else {
            Button {
                self.toastOptions = .successAddPokemon
                self.showToastAdd = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } label: {
                getFavouriteButtonView(for: "catch_in_pokeball")
            }
        }
    }
    
    private func handleImageDoubleTap() {
        if !FavouritePokemonsManager.shared.checkIfIsSaved(id) {
            self.isImageDoubleClicked = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + PokeballAnimation.duration) {
                FavouritePokemonsManager.shared.addPokemonId(id)
                self.isImageDoubleClicked = false
            }
        }
    }
    
    private func shouldPokemonTypeBeVisible(_ index: Int) -> Bool {
        if !arePokemonTypesCountOdd() {
            return true
        } else {
            if pokemon!.types.count - 1 != index {
                return true
            } else {
                return false
            }
        }
    }
    
    private func arePokemonTypesCountOdd() -> Bool {
        return pokemon!.types.count % 2 == 1
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
    
    private func getFavouriteButtonView(for text: String) -> some View {
        return Text(LocalizedStringKey(text))
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

#Preview {
    DetailedPokemonView(id: 1)
}
