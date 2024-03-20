//
//  PokemonImage.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct PokemonImage: View {
    var image: Image?
    var width: CGFloat
    var isInMyPokedex: Bool


    var body: some View {
        ZStack {
            if image != nil && image != Image("PokemonWithoutImage") {
                Circle()
                    .frame(width: width)
                    .foregroundStyle(Color("PokemonBackgroundColor").opacity(0.6))

                image!
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
            } else {
                Circle()
                    .frame(width: width)
                    .foregroundStyle(Color("NonePokemonBackgroundColor").opacity(0.6))

                Image("PokemonWithoutImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
            }
            
            if isInMyPokedex {
                Image(.pokeball)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 4)
                    .offset(x: width * 25 / 64, y: -width * 25 / 64)
            }
            
        }
        .padding()
    }
}

#Preview {
    PokemonImage(image: nil, width: 100, isInMyPokedex: true)
}
