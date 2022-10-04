//
//  CollectionViewCell.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 29/09/2022.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
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

	func configureView() {}
}
