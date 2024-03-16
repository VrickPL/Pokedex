//
//  PokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonView: View {
    @State private var pokemon: Pokemon?
    
    var body: some View {
        VStack {
            if pokemon == nil {
                LoadingView()
            } else {
                Text(pokemon?.name ?? "Hello world")
            }
        }
        .task {
            do {
                pokemon = try await PokemonViewModel().getPokemon()
            } catch PokemonError.invalidData {
                
            } catch PokemonError.invalidResponse {
                
            } catch PokemonError.invalidUrl {
                
            } catch {
                //unexpected
            }
        }
    }
}

#Preview {
    PokemonView()
}
