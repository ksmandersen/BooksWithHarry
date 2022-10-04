//
//  SearchResultsView.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 29/09/2022.
//

import Foundation
import UIKit

class SearchResultsView: UIView {
	lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
		collectionView.contentInsetAdjustmentBehavior = .never
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.accessibilityIdentifier = "searchResultCollectionView"
		
		return collectionView
	}()

	init() {
		super.init(frame: .zero)
		configureView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureView() {
		addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}

	private func createLayout() -> UICollectionViewCompositionalLayout {
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.scrollDirection = .vertical

		return .init(sectionProvider: { index, env in
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												  heightDimension: .fractionalHeight(1.0))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)

			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												   heightDimension: .absolute(100))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
														   subitems: [item])

			let section = NSCollectionLayoutSection(group: group)

			// we need to add the section header here
			let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													heightDimension: .estimated(100))
			let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
																			elementKind: UICollectionView.elementKindSectionFooter,
																			alignment: .bottom)

			let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													heightDimension: .absolute(200))
			let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
																			elementKind: UICollectionView.elementKindSectionHeader,
																			alignment: .top)

			section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

			return section
		}, configuration: config)
	}
}
