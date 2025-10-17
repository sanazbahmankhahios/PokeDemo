//
//  EmptyDescriptionMockService.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import Foundation
 class EmptyDescriptionMockService: PokemonServiceProtocol {
    
    func favorite(pokemon: Pokemon) async throws {
           throw NetworkError.requestFailed
       }
    
    func fetchPokemonList(limit: Int, offset: Int) async throws -> [Pokemon] {
        return [Pokemon(name: "Ditto", url: URL(string: "https://pokeapi.co/api/v2/pokemon/132/")!)]
    }

    func fetchPokemonDescription(for pokemon: Pokemon) async throws -> [String] {
        return []
    }
}
