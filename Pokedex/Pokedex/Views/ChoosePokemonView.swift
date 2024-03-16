//
//  ChoosePokemonView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct ChoosePokemonView: View {
    @State private var pokemonsData: PokemonsData?
    
    var body: some View {
        VStack {
            if pokemonsData == nil {
                LoadingView()
            } else {
                Text(pokemonsData?.results[2].name ?? "Hello world")
            }
        }
        .task {
            do {
                pokemonsData = try await ChoosePokemonViewModel().getPokemons()
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
    ChoosePokemonView()
}
