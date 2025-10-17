//
//  PokemonSpecies.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
struct PokemonSpecies: Codable {
    struct FlavorTextEntry: Codable {
        let flavor_text: String
        let language: Language
        struct Language: Codable { let name: String }
    }
    let flavor_text_entries: [FlavorTextEntry]
}
