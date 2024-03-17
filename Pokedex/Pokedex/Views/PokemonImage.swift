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
    var isInMyPokedex: Bool
    
    init(image: Image? = nil, width: CGFloat, isInMyPokedex: Bool) {
        self.image = image
        self.width = width
        self.isInMyPokedex = isInMyPokedex
    }
  
    init(image: Image?, width: CGFloat) {
        self.image = image
        self.width = width
        self.isInMyPokedex = false
    }

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
            
//            let image = if isInMyPokedex {
//                Image(systemName: "heart.fill")
//                    .resizable()
//                    .foregroundColor(.red)
//            } else {
//                Image(systemName: "heart")
//                    .resizable()
//                    .foregroundColor(.white)
//            }
//            
//            image
//                .scaledToFit()
//                .frame(width: width / 4)
//                .offset(x: width / 2 - 20, y: -width / 2 + 20)\
            
            if isInMyPokedex {
                Image(.pokeball)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 4)
                    .offset(x: width / 2 - 20, y: -width / 2 + 20)
                
            }
            
        }
        .padding()
    }
}

#Preview {
    PokemonImage(image: nil, width: 100, isInMyPokedex: true)
}
