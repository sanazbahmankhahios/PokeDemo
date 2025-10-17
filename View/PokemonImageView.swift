//
//  PokemonImageView.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit
import Kingfisher

final class PokemonImageView: UIView {
    private static let placeholder = UIImage(systemName: "photo")
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setImage(with url: URL?) {
        imageView.kf.setImage(
            with: url,
            placeholder: Self.placeholder,
            options: [.transition(.fade(0.3))]
        )
    }
    
    func configure(with pokemon: Pokemon) {
        setImage(with: PokemonImageHelper.imageURL(for: pokemon))
    }
    
    func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = Self.placeholder
    }
}
