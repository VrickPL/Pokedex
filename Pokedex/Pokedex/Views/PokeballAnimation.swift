//
//  PokeballAnimation.swift
//  Pokedex
//
//  Created by Jan Kazubski on 23/03/2024.
//

import SwiftUI

struct PokeballAnimation: View {
    @State private var size = 1.5
    static var width = UIScreen.main.bounds.width / 15
    static var duration = 0.2

    var body: some View {
        Image(.pokeball)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: PokeballAnimation.width)
            .scaleEffect(size)
            .onAppear {
                withAnimation(.easeIn(duration: PokeballAnimation.duration)) {
                    self.size = 1
                }
            }
    }
}

#Preview {
    PokeballAnimation()
}
