//
//  AppCoordinator.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let service: PokemonServiceProtocol
    private var pokemonCoordinator: PokemonCoordinator?
    
    init(window: UIWindow, service: PokemonServiceProtocol) {
        self.window = window
        self.service = service
    }
    
    func start() {
        let navigationController = UINavigationController()
        let container = DIContainer(service: service)
        pokemonCoordinator = PokemonCoordinator(
            navigationController: navigationController,
            container: container
        )
        pokemonCoordinator?.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
