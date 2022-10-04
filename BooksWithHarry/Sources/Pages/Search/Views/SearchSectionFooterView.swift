//
//  SearchSectionFooterView.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 30/09/2022.
//

import Foundation
import UIKit

class SearchSectionFooterView: UICollectionReusableView, ReusableView {
	lazy var loadingIndicatorView: UIActivityIndicatorView = {
		let indicatorView = UIActivityIndicatorView(style: .medium)
		indicatorView.translatesAutoresizingMaskIntoConstraints = false
		indicatorView.tintColor = .darkGray
		indicatorView.hidesWhenStopped = true

		return indicatorView
	}()

	override public init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}

	convenience init() {
		self.init(frame: CGRect.zero)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configureView()
	}

	func configureView() {
		loadingIndicatorView.startAnimating()
		addSubview(loadingIndicatorView)
		NSLayoutConstraint.activate([
			loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
			loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
}
