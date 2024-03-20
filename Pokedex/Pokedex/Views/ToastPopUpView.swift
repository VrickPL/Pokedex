//
//  ToastPopUpView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 20/03/2024.
//

import Foundation
import SwiftUI
import SimpleToast

struct ToastPopUpView: View {
    @State var text: String
    @State var color: Color?
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(text))
        }
        .padding(20)
        .background(color)
        .opacity(0.8)
        .foregroundColor(.white)
        .cornerRadius(14)
    }
}

func getToastConfig() -> SimpleToastOptions {
    return SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        animation: .default,
        modifierType: .slide,
        dismissOnTap: true
    )
}


#Preview {
    ToastPopUpView(text: "success_add_pokemon", color: .green)
}
