//
//  ToolbarView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct ToolbarView: View {
    var body: some View {
        TabView {
            Group {
                ChoosePokemonView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("APP_NAME")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("profile")
                    }
            }
            .toolbarBackground(Color("ToolbarColor"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    ToolbarView()
}
