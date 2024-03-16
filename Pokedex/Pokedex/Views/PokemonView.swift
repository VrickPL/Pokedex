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
    
    private let pokemonWidth = UIScreen.main.bounds.width / 2

    var body: some View {
        VStack {
            if pokemon == nil {
                LoadingView()
            } else {
                if let image = image {
                    PokemonImage(image: image, width: pokemonWidth)
                } else {
                    LoadingView()
                }

                Text(pokemon!.name.capitalized)
                    .font(.custom("PressStart2P-Regular", size: 18))
                    .padding(.bottom)
                
                HStack {
                    Text("Weight: ").bold()
                    Text("\(pokemon!.weight / 10)kg")
                    Spacer()
                }
                HStack {
                    Text("Height: ").bold()
                    Text("\(pokemon!.height * 10)cm")
                    Spacer()
                }
            }
        }
        .padding()
        .task {
            do {
                pokemon = try await PokemonViewModel(id: id).getPokemon()
            } catch {
                // TODO: implement toast
            }
        }
        .task {
            if image == nil {
                do {
                    image = try await PokemonViewModel(id: id).getPokemonImage()
                } catch {
                    // TODO: implement toast
                }
            }
        }
    }
}

#Preview {
    PokemonView(id: 1)
}