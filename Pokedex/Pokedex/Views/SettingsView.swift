//
//  SettingsView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedLanguage = "auto"
    @State private var selectedTheme = "auto"
    @State var search: Bool
    
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
        .onDisappear {
            // TODO: save in UserDefaults
        }
    }
        
}

#Preview {
    SettingsView(search: true)
}
