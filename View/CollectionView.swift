//
//  CollectionView.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

final class CollectionView: UIView {
    private var pokemons: [Pokemon] = []
    var onSelectPokemon: ((Pokemon) -> Void)?
    var onAppearPokemon: ((Pokemon) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, environment in
            LayoutFactory.createAdaptiveLayoutSection(using: environment)
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        return view
    }()
    
    private lazy var dataSource = makeDataSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func update(with pokemons: [Pokemon], animated: Bool = true) {
        self.pokemons = pokemons
        applySnapshot(animated: animated)
    }
}

private extension CollectionView {
    
    func setupView() {
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Pokemon.ID> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, id in
            guard
                let self,
                let pokemon = self.pokemons.first(where: { $0.id == id }),
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PokemonCell.reuseIdentifier,
                    for: indexPath) as? PokemonCell
            else { return UICollectionViewCell() }
            cell.configure(with: pokemon)
            return cell
        }
    }
    
    func applySnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Pokemon.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(pokemons.map { $0.id })
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension CollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < pokemons.count else { return }
        onSelectPokemon?(pokemons[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let last = pokemons.last,
            scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.height - CollectionViewConstants.preloadThreshold
        else { return }
        onAppearPokemon?(last)
    }
}

