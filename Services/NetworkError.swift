//
//  NetworkError.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case badResponse
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "Network request failed"
        case .badResponse:
            return "Received an unsuccessful response from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .encodingError:
            return "Failed to encode the response."
        }
    }
}
