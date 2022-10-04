//
//  SearchQueryHeaderView.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 04/10/2022.
//

import Foundation
import UIKit

class SearchQueryHeaderView: UICollectionReusableView, ReusableView {
	lazy var queryLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.textAlignment = .center
		label.font = .preferredFont(forTextStyle: .title1)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}

	convenience init() {
		self.init(frame: .zero)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configureView()
	}

	func configureView() {
		backgroundColor = .lightGray
		
		addSubview(queryLabel)
		NSLayoutConstraint.activate([
			queryLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
			queryLabel.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
			queryLabel.centerYAnchor.constraint(equalTo: readableContentGuide.centerYAnchor)
		])
	}
}
