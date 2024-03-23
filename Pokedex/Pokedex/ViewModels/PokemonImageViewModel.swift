//
//  PokemonImageViewModel.swift
//  Pokedex
//
//  Created by Jan Kazubski on 22/03/2024.
//

import Foundation
import SwiftUI
import SVGKit

class PokemonImageViewModel {
    private var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func getSmallPokemonImage() async throws -> Image {
        let endpoint = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        guard let url = URL(string: endpoint) else {
            throw PokemonError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PokemonError.invalidResponse
        }
        
        guard let uiImage = UIImage(data: data) else {
            throw PokemonError.invalidData
        }
            
        return Image(uiImage: uiImage)
    }
    
    func getBigPokemonImage() async throws -> Image? {
        let svgEndpoint = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/\(id).svg"
        guard let url = URL(string: svgEndpoint) else {
            throw PokemonError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PokemonError.invalidResponse
        }
        
        let svgImage = SVGKImage(data: data)
        
        guard let uiImage = svgImage?.uiImage else {
            throw PokemonError.invalidData
        }
            
        return Image(uiImage: uiImage)
    }
}
