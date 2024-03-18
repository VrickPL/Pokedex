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
        }
        .padding()
    }
}

#Preview {
    PokemonImage(width: 100)
}
