//
//  SettingsView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(Keys.selectedLanguageKey) private var selectedLanguage = "auto"
    @AppStorage(Keys.selectedThemeKey) private var selectedTheme = "auto"
    @AppStorage(Keys.searchKey) private var search = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("language")) {
                    Picker("language", selection: $selectedLanguage) {
                        Text("auto").tag("auto")
                        Text("english").tag("english")
                        Text("polish").tag("polish")
                    }
                }
                Section(header: Text("theme")) {
                    Picker("theme", selection: $selectedTheme) {
                        Text("auto").tag("auto")
                        Text("light").tag("light")
                        Text("dark").tag("dark")
                    }
                }
                Section(header: Text("search")) {
                    Toggle("search_by_name", isOn: $search)
                        .toggleStyle(SwitchToggleStyle())
                }
            }
        }
        .navigationTitle("settings")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private struct Keys {
        static let selectedLanguageKey = "selectedLanguage"
        static let selectedThemeKey = "selectedTheme"
        static let searchKey = "searchBool"
    }
}

#Preview {
    SettingsView()
}
