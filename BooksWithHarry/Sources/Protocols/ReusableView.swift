//
//  ReusableView.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 29/09/2022.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
	static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UICollectionViewCell {
	static var defaultReuseIdentifier: String {
		return String(describing: Self.self)
	}
}

extension ReusableView where Self: UICollectionReusableView {
	static var defaultReuseIdentifier: String {
		return String(describing: Self.self)
	}
}
