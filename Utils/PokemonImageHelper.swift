//
//  PokemonImageHelper.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import Foundation

struct PokemonImageHelper {
    static func imageURL(for pokemon: Pokemon) -> URL? {
       URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")
    }
}
