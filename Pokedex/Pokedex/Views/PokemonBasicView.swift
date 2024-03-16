//
//  PokemonBasicView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonBasicView: View {
    @State var image: UIImage?
    @State var pokemon: PokemonBasic?

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: width)
                    .foregroundStyle(Color.blue.opacity(0.2))
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
                }
            }
                .padding()
            
            if let pokemon = pokemon {
                Text(pokemon.name)
                    .font(.custom("PressStart2P-Regular", size: 16))
            }
        }
    }
    
    private let width = UIScreen.main.bounds.width * 2 / 5
}

#Preview {
    PokemonBasicView()
}
