//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Jan Kazubski on 16/03/2024.
//

import SwiftUI
import TipKit

@main
struct PokedexApp: App {
    @AppStorage(Keys.selectedThemeKey) private var selectedTheme: Theme = .systemDefault
    @AppStorage(Keys.selectedLanguageKey) private var selectedLanguage: Language = .systemDefault

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .preferredColorScheme(selectedTheme.colorScheme)
                .environment(\.locale, selectedLanguage.locale)
                .task {
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
