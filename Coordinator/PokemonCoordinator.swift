//
//  PokemonCoordinator.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

@MainActor
protocol PokemonCoordinatorProtocol {
    func showDetail(_ viewController: UIViewController)
}

final class PokemonCoordinator: PokemonCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let container: DIContainer
    private var listViewModel: PokemonListViewModel?
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let viewModel = container.makePokemonListViewModel(coordinator: self)
        self.listViewModel = viewModel
        let listViewContoller = PokemonListViewController(viewModel: viewModel)
        navigationController.setViewControllers([listViewContoller], animated: false)
    }
    
    func showDetail(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
