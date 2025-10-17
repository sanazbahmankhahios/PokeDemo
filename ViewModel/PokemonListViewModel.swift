//
//  PokemonListViewModel.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published private(set) var pokemons: [Pokemon] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    private let coordinator: PokemonCoordinatorProtocol
    private let service: PokemonServiceProtocol
    private let limit = 20
    
    init(service: PokemonServiceProtocol, coordinator: PokemonCoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func loadPokemons() async {
        guard !isLoading, pokemons.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            pokemons = try await service.fetchPokemonList(limit: limit, offset: 0)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadMorePokemons(lastItem: Pokemon) async {
        guard !isLoading else { return }
        guard let index = pokemons.firstIndex(where: { $0.id == lastItem.id }),
              index + 1 == pokemons.count else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newPokemons = try await service.fetchPokemonList(limit: limit, offset: index + 1)
            pokemons.append(contentsOf: newPokemons)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func update(pokemon: Pokemon) {
        guard let index = pokemons.firstIndex(where: { $0.id == pokemon.id }) else { return }
        pokemons[index] = pokemon
    }

    func showDetail(for pokemon: Pokemon) {
          let detailViewModel = PokemonDetailViewModel(pokemon: pokemon, service: service)
          let detailViewController = PokemonDetailViewController(viewModel: detailViewModel) { [weak self] updatedPokemon in
              self?.update(pokemon: updatedPokemon)
          }
          coordinator.showDetail(detailViewController)
      }
}

