//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI

@main
struct PokedexApp: App {
    @AppStorage(Keys.selectedThemeKey) private var selectedTheme: Theme = .systemDefault

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .preferredColorScheme(selectedTheme.colorScheme)
        }
    }
}
