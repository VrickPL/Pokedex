//
//  ContentView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            ChoosePokemonView()
        }
    }
}

#Preview {
    ContentView()
}
