//
//  PokemonListViewController.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

final class PokemonListViewController: UIViewController {
    private let viewModel: PokemonListViewModel
    private let collectionView = CollectionView()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupCollectionViewCallbacks()
        bindViewModel()
        loadInitialPokemons()
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(spinner)
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.hidesWhenStopped = true
    }
    
    func setupCollectionViewCallbacks() {
        collectionView.onSelectPokemon = { [weak self] pokemon in
            guard let self else { return }
            self.viewModel.showDetail(for: pokemon)
        }
        collectionView.onAppearPokemon = { [weak self] pokemon in
            guard let self else { return }
            Task { await self.viewModel.loadMorePokemons(lastItem: pokemon) }
        }
    }
    
    func bindViewModel() {
        Task {
            for await pokemons in viewModel.$pokemons.values {
                collectionView.update(with: pokemons, animated: true)
            }
        }
        
        Task {
            for await error in viewModel.$errorMessage.values {
                guard let error else { continue }
                print("Error:", error)
            }
        }
        
        Task {
            for await isLoading in viewModel.$isLoading.values {
                isLoading ? spinner.startAnimating() : spinner.stopAnimating()
            }
        }
    }
    
    func loadInitialPokemons() {
        Task { await viewModel.loadPokemons() }
    }
}

