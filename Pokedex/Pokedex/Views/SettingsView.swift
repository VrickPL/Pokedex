//
//  SettingsView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(Keys.selectedLanguageKey) private var selectedLanguage: Language = Language.systemDefault
    @AppStorage(Keys.selectedThemeKey) private var selectedTheme: Theme = Theme.systemDefault
    @AppStorage(Keys.searchKey) private var search = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("language")) {
                    Picker("language", selection: $selectedLanguage) {
                        ForEach(Language.allCases, id: \.rawValue) { language in
                            Text(LocalizedStringKey(language.rawValue)).tag(language)
                        }
                    }
                }
                Section(header: Text("theme")) {
                    Picker("theme", selection: $selectedTheme) {
                        ForEach(Theme.allCases, id: \.rawValue) { theme in
                            Text(LocalizedStringKey(theme.rawValue)).tag(theme)
                        }
                    }
                }
                Section(header: Text("search")) {
                    Toggle("search_by_name", isOn: $search)
                        .toggleStyle(SwitchToggleStyle())
                }
            }
        }
        .environment(\.locale, selectedLanguage.locale)
        .preferredColorScheme(selectedTheme.colorScheme)
    }
}

struct Keys {
    static let selectedLanguageKey = "selectedLanguage"
    static let selectedThemeKey = "selectedTheme"
    static let searchKey = "searchBool"
}

#Preview {
    SettingsView()
}
