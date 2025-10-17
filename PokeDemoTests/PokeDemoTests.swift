//
//  PokeDemoTests.swift
//  PokeDemoTests
//
//  Created by sanaz on 10/17/25.
//

import XCTest
@testable import PokeDemo

@MainActor
final class PokemonViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var container: DIContainer!
    var mockService: MockService!
    
    override func setUp() async throws {
        mockService = MockService()
        container = DIContainer(service: mockService)
        viewModel = container.makePokemonListViewModel(coordinator: MockCoordinator())
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        container = nil
        super.tearDown()
    }
    
    func testPokemonID() {
        let bulbasaur = Pokemon(name: "Bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        XCTAssertEqual(bulbasaur.id, 1)
        let charmander = Pokemon(name: "Charmander", url: URL(string: "https://pokeapi.co/api/v2/pokemon/4/")!)
        XCTAssertEqual(charmander.id, 4)
        let unknown = Pokemon(name: "Unknown", url: URL(string: "https://pokeapi.co/api/v2/pokemon/")!)
        XCTAssertEqual(unknown.id, 0)
    }
    
    func testLoadPokemons() async throws {
        await viewModel.loadPokemons()
        XCTAssertEqual(viewModel.pokemons.count, 6)
        XCTAssertEqual(viewModel.pokemons.first?.name, "Bulbasaur")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadPokemonsFailure() async throws {
        let failingContainer = DIContainer(service: FailingMockService())
        let failingViewModel = failingContainer.makePokemonListViewModel(coordinator: MockCoordinator())
        await failingViewModel.loadPokemons()
        
        XCTAssertEqual(failingViewModel.pokemons.count, 0)
        XCTAssertEqual(failingViewModel.errorMessage, NetworkError.requestFailed.localizedDescription)
    }
    
    func testFetchDescriptions() async throws {
        let pokemon = Pokemon(name: "Bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        let detailViewModel = PokemonDetailViewModel(pokemon: pokemon, service: mockService)
        await detailViewModel.fetchDescription()
        
        XCTAssertEqual(detailViewModel.descriptions.count, 6)
        XCTAssertTrue(detailViewModel.descriptions.contains { $0.contains("Bulbasaur is a starter Pokémon!") })
    }
    
    func testFetchDescriptionEmpty() async throws {
        let emptyContainer = DIContainer(service: EmptyDescriptionMockService())
        let pokemon = Pokemon(name: "Ditto", url: URL(string: "https://pokeapi.co/api/v2/pokemon/132/")!)
        let detailViewModel = emptyContainer.makePokemonDetailViewModel(pokemon: pokemon)
        await detailViewModel.fetchDescription()
        
        XCTAssertEqual(detailViewModel.descriptions, ["No description available"])
    }
    
    func testFavoritePokemonFailure() async {
        mockService.shouldFavoriteSucceed = false
        let pokemon = Pokemon(name: "Pikachu", url: URL(string:"https://pokeapi.co/api/v2/pokemon/25/")!)
        
        do {
            _ = try await container.service.favorite(pokemon: pokemon)
            XCTFail("Expected NetworkError.requestFailed but got success")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testCleanDescription() {
        let service = PokemonService()
        XCTAssertEqual(service.cleanDescription("\nBulbasaur is a starter Pokémon!\u{0C}  "), "Bulbasaur is a starter Pokémon!")
        XCTAssertEqual(service.cleanDescription("   \n\u{0C}  "), "")
        XCTAssertEqual(service.cleanDescription("Pikachu"), "Pikachu")
    }
}


