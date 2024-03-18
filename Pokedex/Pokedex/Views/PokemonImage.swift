//
//  PokemonImage.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonImage: View {
    var image: Image?
    @State var width: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .frame(width: width)
                .foregroundStyle(Color("PokemonBackgroundColor").opacity(0.6))
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
            } else {
                Image("PokemonWithoutImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
            }
        }
        .padding()
    }
}

#Preview {
    PokemonImage(width: 100)
}
