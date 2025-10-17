//
//  PokemonDetailViewModel.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import Foundation

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon
    @Published var descriptions: [String] = []
    @Published var isLoading = false
    @Published var isFavorite = false
    
    private let service: PokemonServiceProtocol
    private var isProcessing = false
    var name: String { pokemon.name.capitalized }
    
    init(pokemon: Pokemon, service: PokemonServiceProtocol) {
        self.pokemon = pokemon
        self.service = service
        self.isFavorite = pokemon.isFavorite
    }
    
    func fetchDescription() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedDescriptions = try await service.fetchPokemonDescription(for: pokemon)
            descriptions = fetchedDescriptions.isEmpty ? ["No description available"] : fetchedDescriptions
        } catch {
            descriptions = ["No description available"]
        }
    }
    
    func toggleFavorite() async {
        guard !isProcessing else { return }
        isProcessing = true
        defer { isProcessing = false }
        
        isFavorite.toggle()
        pokemon.isFavorite = isFavorite
        
        if isFavorite {
            do {
                try await service.favorite(pokemon: pokemon)
            } catch {
                print("Failed to favorite Pokémon: \(error)")
            }
        }
    }
}

