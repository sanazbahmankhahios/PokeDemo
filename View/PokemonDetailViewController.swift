//
//  PokemonDetailViewController.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

final class PokemonDetailViewController: UIViewController {
    private let viewModel: PokemonDetailViewModel
    private let onFavorite: ((Pokemon) -> Void)
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let imageView = PokemonImageView()
    private let nameLabel = UILabel()
    private let descriptionStack = UIStackView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: PokemonDetailViewModel, onFavorite: @escaping ((Pokemon) -> Void)) {
        self.viewModel = viewModel
        self.onFavorite = onFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureContentView()
        setupConstraints()
        setupFavoriteButton()
        bindViewModel()
        loadDescription()
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    func configureContentView() {
        contentView.axis = .vertical
        contentView.spacing = 8
        
        [imageView, nameLabel, descriptionStack, loadingIndicator].forEach {
            contentView.addArrangedSubview($0)
        }
        
        imageView.configure(with: viewModel.pokemon)
        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.text = viewModel.name
        nameLabel.textAlignment = .center
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 8
        loadingIndicator.hidesWhenStopped = true
    }
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupFavoriteButton() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapFavorite)
        )
        navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButton()
    }
    
    
    @objc private func didTapFavorite() {
        Task {
            await viewModel.toggleFavorite()
            onFavorite(viewModel.pokemon)
            updateFavoriteButton()
        }
    }
    
    func bindViewModel() {
        Task {
            for await descriptions in viewModel.$descriptions.values {
                updateDescriptions(descriptions)
            }
        }
        
        Task {
            for await isLoading in viewModel.$isLoading.values {
                isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            }
        }
        
        Task {
            for await _ in viewModel.$isFavorite.values {
                updateFavoriteButton()
            }
        }
    }
    
    func updateDescriptions(_ descriptions: [String]) {
        for description in descriptions {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.text = description
            descriptionStack.addArrangedSubview(label)
        }
    }
    
    func updateFavoriteButton() {
        guard let favoriteButton = navigationItem.rightBarButtonItem else { return }
        favoriteButton.image = UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
        favoriteButton.tintColor = viewModel.isFavorite ? .systemRed : .label
    }
    
    func loadDescription() {
        Task { await viewModel.fetchDescription() }
    }
}

