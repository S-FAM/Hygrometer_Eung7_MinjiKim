//
//  HomeUtilities.swift
//  Hygrometer
//
//  Created by 김응철 on 2022/08/04.
//

import UIKit

class HomeUtilities {
  func createSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.9))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Measure.Home.collectionViewInset)

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8.0
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16)

    return section
  }

  func createLayout() -> UICollectionViewCompositionalLayout {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    let section = createSection()

    return UICollectionViewCompositionalLayout(section: section, configuration: config)
  }
}
