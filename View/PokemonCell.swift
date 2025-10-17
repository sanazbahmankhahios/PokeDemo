//
//  PokemonCell.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

final class PokemonCell: UICollectionViewCell {
    static let reuseIdentifier = "PokemonCell"
    
    private let pokemonImageView = PokemonImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        configureShadow()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupView() {
        contentView.addSubview(containerView)
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        pokemonImageView.configure(with: pokemon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.prepareForReuse()
        nameLabel.text = nil
    }
}
