//
//  DIContainer.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
@MainActor
final class DIContainer {
    let service: PokemonServiceProtocol

    init(service: PokemonServiceProtocol) {
        self.service = service
    }

    func makePokemonListViewModel(coordinator: PokemonCoordinatorProtocol) -> PokemonListViewModel {
        PokemonListViewModel(service: service, coordinator: coordinator)
    }

    func makePokemonDetailViewModel(
        pokemon: Pokemon
    ) -> PokemonDetailViewModel {
        PokemonDetailViewModel(pokemon: pokemon, service: service)
    }
}
