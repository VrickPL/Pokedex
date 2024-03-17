//
//  SplashScreenView.swift
//  Pokedex
//
//  Created by Jan Kazubski on 17/03/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Image("pokeball")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                        Text(LocalizedStringKey("APP_NAME"))
                            .font(Font.custom("PressStart2P-Regular", size: 26))
                            .opacity(0.8)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }.overlay(
                    Text(LocalizedStringKey("author"))
                        .foregroundStyle(.gray),
                    alignment: .bottom)
        }
    }
}


#Preview {
    SplashScreenView()
}
