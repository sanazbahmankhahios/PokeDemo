//
//  PokemonService.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> [Pokemon]
    func fetchPokemonDescription(for pokemon: Pokemon) async throws -> [String]
    func favorite(pokemon: Pokemon) async throws
}

final class PokemonService: PokemonServiceProtocol {
    private let maxDescriptions = 6
    
    /// Source documentation: `https://pokeapi.co/docs/v2#pokemon`
    func fetchPokemonList(limit: Int, offset: Int) async throws -> [Pokemon] {
        guard var components = URLComponents(string: "\(NetworkConstants.baseURL)pokemon") else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try validateHTTPResponse(response)
            
            let decoded = try JSONDecoder().decode(PokemonResponse.self, from: data)
            return decoded.results
            
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw error
        }
    }
    
    /// Source documentation:: `https://pokeapi.co/docs/v2#pokemon-species`
    func fetchPokemonDescription(for pokemon: Pokemon) async throws -> [String] {
        guard let baseURL = URL(string: NetworkConstants.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let url = baseURL
            .appendingPathComponent("pokemon-species")
            .appendingPathComponent("\(pokemon.id)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try validateHTTPResponse(response)
            
            let species = try JSONDecoder().decode(PokemonSpecies.self, from: data)
            
            /// Extracts unique English descriptions, normalizing text by removing line breaks, form feeds, and extra whitespace.
            let uniqueDescriptions = species.flavor_text_entries
                .filter { $0.language.name == "en" }
                .map { cleanDescription($0.flavor_text) }
                .reduce(into: [String]()) { results, text in
                    if !results.contains(text) { results.append(text) }
                }
            return Array(uniqueDescriptions.prefix(maxDescriptions))
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.requestFailed
        }
    }
    
    /// Source documentation: `http://webhook.site`
    func favorite(pokemon: Pokemon) async throws {
        let url = URL(string: "https://webhook.site/e10315c8-a86e-4bf5-ae3e-2a346b97c255")! // swiftlint:disable:this force_unwrapping
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(pokemon)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            try validateHTTPResponse(response)
            
        } catch is EncodingError {
            throw NetworkError.encodingError
        } catch {
            throw NetworkError.requestFailed
        }
    }
    
    private func validateHTTPResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }
    }
    
    func cleanDescription(_ text: String) -> String {
        text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{0C}", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
