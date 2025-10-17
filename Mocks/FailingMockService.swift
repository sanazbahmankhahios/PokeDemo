//
//  FailingMockService.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import Foundation

 class FailingMockService: PokemonServiceProtocol {
    
    func favorite(pokemon: Pokemon) async throws {
           throw NetworkError.requestFailed
       }
    
    func fetchPokemonList(limit: Int, offset: Int) async throws -> [Pokemon] {
        throw NetworkError.requestFailed
    }
    func fetchPokemonDescription(for pokemon: Pokemon) async throws -> [String] {
        throw NetworkError.requestFailed
    }
}
