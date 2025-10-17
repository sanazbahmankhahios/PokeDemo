//
//  LayoutFactory.swift
//  PokeDemo
//
//  Created by sanaz on 10/17/25.
//
import UIKit

struct LayoutFactory {
    static func createAdaptiveLayoutSection(using environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let width = environment.container.effectiveContentSize.width
        let spacing = CollectionViewConstants.itemSpacing
        let inset = CollectionViewConstants.sectionInset
        let availableWidth = width - (inset * 2)
        let columnCount = max(Int((availableWidth + spacing) / (CollectionViewConstants.minimumItemWidth + spacing)), 1)
        let fraction = 1 / CGFloat(columnCount)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        return section
    }
}
